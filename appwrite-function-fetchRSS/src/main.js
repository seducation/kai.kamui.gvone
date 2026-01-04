const sdk = require('node-appwrite');
const Parser = require('rss-parser');
const crypto = require('crypto');

module.exports = async function ({ req, res, log, error }) {
    const client = new sdk.Client();
    const databases = new sdk.Databases(client);
    const parser = new Parser({
        customFields: {
            item: ['media:content', 'media:thumbnail', 'enclosure', 'content:encoded'],
        },
    });

    if (
        !process.env.APPWRITE_FUNCTION_ENDPOINT ||
        !process.env.APPWRITE_FUNCTION_PROJECT_ID ||
        !process.env.APPWRITE_FUNCTION_API_KEY ||
        !process.env.DATABASE_ID
    ) {
        throw new Error('Missing required environment variables');
    }

    client
        .setEndpoint(process.env.APPWRITE_FUNCTION_ENDPOINT)
        .setProject(process.env.APPWRITE_FUNCTION_PROJECT_ID)
        .setKey(process.env.APPWRITE_FUNCTION_API_KEY);

    const DATABASE_ID = process.env.DATABASE_ID;
    const TV_PROFILES_COLLECTION = 'tv_profiles';
    const TV_POSTS_COLLECTION = 'tv_posts';

    try {
        let profilesToUpdate = [];

        // 1. Determine Scope (Single Profile or All)
        let payload = {};
        try {
            if (req.body) {
                payload = typeof req.body === 'string' ? JSON.parse(req.body) : req.body;
            }
        } catch (e) {
            log('Failed to parse body, proceeding with empty payload');
        }

        if (payload.tvProfileId) {
            log(`Fetching specific profile: ${payload.tvProfileId}`);
            const profile = await databases.getDocument(
                DATABASE_ID,
                TV_PROFILES_COLLECTION,
                payload.tvProfileId
            );
            profilesToUpdate.push(profile);
        } else {
            log('Fetching all active TV profiles...');
            // In production, use cursor pagination for large sets
            const result = await databases.listDocuments(
                DATABASE_ID,
                TV_PROFILES_COLLECTION,
                [
                    sdk.Query.limit(100),
                    // sdk.Query.equal('status', 'active') // if status field exists
                ]
            );
            profilesToUpdate = result.documents;
        }

        log(`Found ${profilesToUpdate.length} profiles to process.`);

        const results = {
            processed: 0,
            added: 0,
            errors: 0
        };

        // 2. Process Each Profile
        for (const profile of profilesToUpdate) {
            log(`Processing: ${profile.name} (${profile.$id})`);

            // rss_url can be comma-separated or array. Handle both.
            let feedUrls = [];
            if (Array.isArray(profile.rss_url)) {
                feedUrls = profile.rss_url;
            } else if (typeof profile.rss_url === 'string') {
                feedUrls = profile.rss_url.split(',').map(u => u.trim()).filter(u => u.length > 0);
            }

            if (feedUrls.length === 0) {
                log(`No RSS URLs for ${profile.name}`);
                continue;
            }

            for (const url of feedUrls) {
                try {
                    log(`Fetching feed: ${url}`);
                    const feed = await parser.parseURL(url);

                    for (const item of feed.items) {
                        // 3. Extract Metadata
                        const title = item.title;
                        const link = item.link;
                        if (!title || !link) continue;

                        const pubDate = item.pubDate ? new Date(item.pubDate) : new Date();
                        const description = item.contentSnippet || item.content || '';

                        // Content extraction (image)
                        let imageUrl = null;
                        if (item.enclosure && item.enclosure.url && item.enclosure.type && item.enclosure.type.startsWith('image')) {
                            imageUrl = item.enclosure.url;
                        } else if (item['media:content'] && item['media:content'].$.url) {
                            imageUrl = item['media:content'].$.url;
                        } else if (item['media:thumbnail'] && item['media:thumbnail'].$.url) {
                            imageUrl = item['media:thumbnail'].$.url;
                        }
                        // Fallback: extract from content HTML if needed (skipped for simplicity)

                        // 4. Generate ID and Deduplicate
                        // Hash(profileId + link) to ensure uniqueness per profile
                        const uniqueString = `${profile.$id}-${link}`;
                        const postRefId = crypto.createHash('md5').update(uniqueString).digest('hex');

                        // Check if exists
                        // We can rely on Appwrite's unique index on post_ref_id constraint to fail creation, 
                        // OR check existence. Checking is safer to avoid log spam of 409 errors.
                        // Based on plan: 'idx_dedup' on (tv_profile_id, post_ref_id).

                        // Actually, 'post_ref_id' should be stored.
                        // To minimize API calls, we could fetch latest posts and compare, but explicit check is safer.
                        const existing = await databases.listDocuments(
                            DATABASE_ID,
                            TV_POSTS_COLLECTION,
                            [
                                sdk.Query.equal('tv_profile_id', profile.$id),
                                sdk.Query.equal('post_ref_id', postRefId),
                                sdk.Query.limit(1)
                            ]
                        );

                        if (existing.total > 0) {
                            // log(`Skipping duplicate: ${title}`);
                            continue;
                        }

                        // 5. Create Post
                        await databases.createDocument(
                            DATABASE_ID,
                            TV_POSTS_COLLECTION,
                            sdk.ID.unique(),
                            {
                                tv_profile_id: profile.$id,
                                post_ref_id: postRefId,
                                title: title,
                                url: link,
                                published_at: pubDate.toISOString(),
                                description: description.substring(0, 1000), // Appwrite limit if any
                                image_url: imageUrl,
                            }
                        );
                        results.added++;
                        log(`Added: ${title}`);
                    }

                } catch (feedErr) {
                    log(`Error fetching/parsing feed ${url}: ${feedErr.message}`);
                    results.errors++;
                }
            }
            results.processed++;
        }

        return res.json({
            success: true,
            data: results
        });

    } catch (err) {
        error("Fatal error: " + err.message);
        return res.json({
            success: false,
            message: err.message
        });
    }
};
