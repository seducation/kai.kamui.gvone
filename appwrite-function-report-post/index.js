
const sdk = require('node-appwrite');

module.exports = async function (req, res) {
  const client = new sdk.Client();
  const databases = new sdk.Databases(client);

  if (
    !req.variables['APPWRITE_FUNCTION_ENDPOINT'] ||
    !req.variables['APPWRITE_FUNCTION_API_KEY']
  ) {
    console.warn("Environment variables are not set. Function cannot use Appwrite SDK.");
    res.json({ success: false, message: "Environment variables are not set." });
    return;
  }

  client
    .setEndpoint(req.variables['APPWRITE_FUNCTION_ENDPOINT'])
    .setProject(req.variables['APPWRITE_FUNCTION_PROJECT_ID'])
    .setKey(req.variables['APPWRITE_FUNCTION_API_KEY']);

  const { postId, reportedBy, reason } = JSON.parse(req.payload);

  if (!postId || !reportedBy || !reason) {
    res.json({ success: false, message: "Missing required parameters." });
    return;
  }

  const databaseId = 'YOUR_DATABASE_ID';
  const postReportsCollectionId = 'post_reports';
  const postsCollectionId = 'posts';

  try {
    // Check if the user has already reported this post
    const existingReports = await databases.listDocuments(
      databaseId,
      postReportsCollectionId,
      [
        sdk.Query.equal('postId', postId),
        sdk.Query.equal('reportedBy', reportedBy)
      ]
    );

    if (existingReports.total > 0) {
      res.json({ success: false, message: "You have already reported this post." });
      return;
    }

    // Check if the user is reporting their own post
    const post = await databases.getDocument(databaseId, postsCollectionId, postId);
    if (post.author.ownerId === reportedBy) {
        res.json({ success: false, message: "You cannot report your own post." });
        return;
    }

    // Create a new report
    await databases.createDocument(
      databaseId,
      postReportsCollectionId,
      'unique()',
      {
        postId,
        reportedBy,
        reason,
      }
    );

    // Increment the report count on the post
    const updatedPost = await databases.updateDocument(
      databaseId,
      postsCollectionId,
      postId,
      {
        reportCount: post.reportCount + 1,
      }
    );

    // If the report count reaches the threshold, hide the post
    if (updatedPost.reportCount >= 20) {
      await databases.updateDocument(
        databaseId,
        postsCollectionId,
        postId,
        {
          isHidden: true,
          status: 'hidden',
        }
      );
    }

    res.json({ success: true, message: "Post reported successfully." });
  } catch (error) {
    console.error(error);
    res.json({ success: false, message: "An error occurred while reporting the post." });
  }
};
