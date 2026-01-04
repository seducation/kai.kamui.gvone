import 'package:flutter/material.dart';
import 'package:my_app/appwrite_service.dart';
import 'package:my_app/model/tv_profile.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class HmvTVTabScreen extends StatefulWidget {
  const HmvTVTabScreen({super.key});

  @override
  State<HmvTVTabScreen> createState() => _HmvTVTabScreenState();
}

class _HmvTVTabScreenState extends State<HmvTVTabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _categoryTabController;
  final List<String> _categories = [
    'All',
    'Tech',
    'News',
    'Education',
    'Business',
    'Entertainment',
  ];

  List<TVProfile> _tvProfiles = [];
  bool _isLoading = false;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _categoryTabController = TabController(
      length: _categories.length,
      vsync: this,
    );
    _categoryTabController.addListener(_onCategoryChanged);
    _loadTVProfiles();
  }

  @override
  void dispose() {
    _categoryTabController.dispose();
    super.dispose();
  }

  void _onCategoryChanged() {
    if (!_categoryTabController.indexIsChanging) {
      setState(() {
        _selectedCategory = _categories[_categoryTabController.index];
      });
      _loadTVProfiles();
    }
  }

  Future<void> _loadTVProfiles() async {
    setState(() => _isLoading = true);

    try {
      final appwriteService = context.read<AppwriteService>();

      final profiles = await appwriteService.getTVProfiles(
        category: _selectedCategory,
      );

      final tvProfiles =
          profiles.rows.map((row) => TVProfile.fromRow(row)).toList();

      setState(() {
        _tvProfiles = tvProfiles;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading TV profiles: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Category tabs
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: TabBar(
              controller: _categoryTabController,
              isScrollable: true,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Theme.of(context).primaryColor,
              tabs: _categories.map((category) => Tab(text: category)).toList(),
            ),
          ),

          // TV Profiles grid
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _tvProfiles.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.tv, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'No TV Profiles found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadTVProfiles,
                        child: GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: _tvProfiles.length,
                          itemBuilder: (context, index) {
                            return _buildTVProfileCard(_tvProfiles[index]);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildTVProfileCard(TVProfile profile) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          context.push('/profile_page/${profile.id}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Container(
                height: 120,
                width: double.infinity,
                color: Colors.blue.shade50,
                child: profile.logoUrl != null
                    ? Image.network(
                        profile.logoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildPlaceholderLogo(),
                      )
                    : _buildPlaceholderLogo(),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name with TV badge
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            profile.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (profile.verified)
                          const Icon(Icons.verified,
                              size: 16, color: Colors.blue),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Category
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        profile.category,
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),

                    const Spacer(),

                    // Followers count
                    Text(
                      '${profile.followersCount} followers',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderLogo() {
    return Container(
      color: Colors.blue.shade100,
      child: Icon(
        Icons.tv,
        size: 48,
        color: Colors.blue.shade300,
      ),
    );
  }
}
