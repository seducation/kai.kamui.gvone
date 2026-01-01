const sdk = require('node-appwrite');

module.exports = async function ({ req, res, log, error }) {
  const client = new sdk.Client();
  const databases = new sdk.Databases(client);
  const users = new sdk.Users(client);


  // Appwrite automatically injects these environment variables
  client
    .setEndpoint(process.env.APPWRITE_FUNCTION_ENDPOINT || 'https://cloud.appwrite.io/v1')
    .setProject(process.env.APPWRITE_FUNCTION_PROJECT_ID || '')
    .setKey(process.env.APPWRITE_FUNCTION_API_KEY || '');

  try {
    // Debug logging to help identify issue
    log("Request Method: " + req.method);
    log("Content-Type: " + (req.headers['content-type'] || 'undefined'));
    log("Request Keys: " + Object.keys(req).join(', '));
    if (req.payload) log("req.payload type: " + typeof req.payload + ", length: " + req.payload.length);
    if (req.body) log("req.body type: " + typeof req.body);

    let payload = {};

    // Priority 1: Pre-parsed JSON (Appwrite 1.4+)
    try {
      if (req.bodyJson && Object.keys(req.bodyJson).length > 0) {
        log("Using req.bodyJson");
        payload = req.bodyJson;
      }
    } catch (err) {
      log("Error accessing req.bodyJson: " + err.message);
    }

    // Priority 2: Raw parse from text (if payload still empty)
    if (Object.keys(payload).length === 0 && req.bodyText) {
      log("Using req.bodyText");
      try {
        payload = JSON.parse(req.bodyText);
      } catch (e) {
        log("Failed to parse bodyText: " + e.message);
      }
    }
    // Priority 3: Legacy/Fallback (body or payload)
    if (Object.keys(payload).length === 0) {
      const rawBody = req.payload || req.body || req.bodyRaw;
      log("Using fallback rawBody type: " + typeof rawBody);
      if (rawBody) log("rawBody content: " + (typeof rawBody === 'string' ? rawBody.substring(0, 1000) : JSON.stringify(rawBody)));

      if (typeof rawBody === 'string') {
        try {
          payload = JSON.parse(rawBody);
        } catch (e) {
          log("Failed to parse rawBody: " + e.message);
        }
      } else if (typeof rawBody === 'object') {
        payload = rawBody;
      }
    }

    const { postId, reporterId, reason } = payload;

    // Log parsed data for verification
    log(`Parsed Data - PostID: ${postId}, ReporterID: ${reporterId}, Reason: ${reason}`);

    if (!postId || !reporterId || !reason) {
      return res.json({ success: false, message: "Missing required parameters." });
    }

    // TODO: Update with your actual Database ID
    const databaseId = 'gvone';
    const reportsCollectionId = 'reports'; // New collection
    const postsCollectionId = 'posts';
    const profilesCollectionId = 'profiles';

    // Thresholds

    const POST_BLOCK_THRESHOLD = 25;
    const PROFILE_BLOCK_THRESHOLD = 10;
    const ACCOUNT_BLOCK_THRESHOLD = 5;


    // 1. Check for duplicate report
    const existingReports = await databases.listDocuments(
      databaseId,
      reportsCollectionId,
      [
        sdk.Query.equal('postId', postId),
        sdk.Query.equal('reporterId', reporterId)
      ]
    );

    if (existingReports.total > 0) {
      return res.json({ success: false, message: "You have already reported this post." });
    }

    // 2. Fetch Post to verify and get author
    const post = await databases.getDocument(databaseId, postsCollectionId, postId);

    if (post.author_id === reporterId || // Assuming author_id is profile ID of author
      (post.author && post.author.$id === reporterId)) {
      return res.json({ success: false, message: "You cannot report your own post." });
    }

    // 3. Create Report
    await databases.createDocument(
      databaseId,
      reportsCollectionId,
      sdk.ID.unique(),
      {
        postId,
        reporterId,
        reason,
        timestamp: new Date().toISOString()
      }
    );

    // 4. Update Post Report Count
    const newReportCount = (post.reportCount || 0) + 1;
    let postUpdates = { reportCount: newReportCount };
    let postBlocked = false;

    if (newReportCount >= POST_BLOCK_THRESHOLD && !post.isBlocked) {
      postUpdates.isBlocked = true;
      postUpdates.blockedAt = new Date().toISOString();
      postBlocked = true;
    }

    await databases.updateDocument(
      databaseId,
      postsCollectionId,
      postId,
      postUpdates
    );

    // 5. Escalate to Profile Level if Post Blocked

    if (postBlocked) {
      const authorProfileId = post.profile_id || post.author.$id;
      const profile = await databases.getDocument(databaseId, profilesCollectionId, authorProfileId);

      const newBlockedPostCount = (profile.blockedPostCount || 0) + 1;
      let profileUpdates = { blockedPostCount: newBlockedPostCount };
      let profileBlocked = false;

      // Check Profile Threshold (10)
      if (newBlockedPostCount >= PROFILE_BLOCK_THRESHOLD && !profile.isBlocked) {
        log(`Profile ${authorProfileId} reached block threshold (${PROFILE_BLOCK_THRESHOLD}). Blocking profile.`);
        profileUpdates.isBlocked = true;
        profileBlocked = true;
      }

      await databases.updateDocument(
        databaseId,
        profilesCollectionId,
        authorProfileId,
        profileUpdates
      );

      // 6. Escalate to Account Level if Profile RECENTLY Blocked
      if (profileBlocked) {
        const ownerId = profile.ownerId;

        // Query all profiles for this user that are BLOCKED
        const blockedProfiles = await databases.listDocuments(
          databaseId,
          profilesCollectionId,
          [
            sdk.Query.equal('ownerId', ownerId),
            sdk.Query.equal('isBlocked', true)
          ]
        );

        // Check Account Threshold (5 blocked profiles)
        if (blockedProfiles.total >= ACCOUNT_BLOCK_THRESHOLD) {
          log(`User ${ownerId} has ${blockedProfiles.total} blocked profiles. Reached threshold (${ACCOUNT_BLOCK_THRESHOLD}). Blocking Account.`);

          // 1. Block User Account
          await users.updateStatus(ownerId, false);

          // 2. Block ALL remaining profiles to ensure they are hidden
          const allUserProfiles = await databases.listDocuments(
            databaseId,
            profilesCollectionId,
            [sdk.Query.equal('ownerId', ownerId)]
          );

          for (const userProfile of allUserProfiles.documents) {
            if (!userProfile.isBlocked) {
              await databases.updateDocument(
                databaseId,
                profilesCollectionId,
                userProfile.$id,
                { isBlocked: true }
              );
              log(`System Blocked profile: ${userProfile.$id} (Account Ban Cascade)`);
            }
          }
        }
      }
    }

    return res.json({ success: true, message: "Report submitted successfully." });

  } catch (err) {
    error("Reporting Error:", err);
    return res.json({ success: false, message: "An error occurred processing the report.", error: err.message });
  }
};
