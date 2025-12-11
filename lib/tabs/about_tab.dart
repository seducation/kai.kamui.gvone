import 'package:flutter/material.dart';
import 'package:my_app/appwrite_service.dart';
import 'package:my_app/model/profile.dart';
import 'package:provider/provider.dart';
class AboutTab extends StatefulWidget {
  final String profileId;
  const AboutTab({super.key, required this.profileId});
  @override
  State<AboutTab> createState() => _AboutTabState();
}
class _AboutTabState extends State<AboutTab> {
  late AppwriteService _appwriteService;
  Profile? _profile;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _appwriteService = context.read<AppwriteService>();
    _loadProfileData();
  }
  Future<void> _loadProfileData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final profile = await _appwriteService.getProfile(widget.profileId);
      if (!mounted) return;
      setState(() {
        _profile = Profile.fromMap(profile.data, profile.$id);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _profile == null
            ? const Center(child: Text("Profile not found"))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_profile!.bio != null && _profile!.bio!.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _profile!.bio!,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const Divider(height: 32),
                        ],
                      ),
                    Text(
                      'Joined',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _profile!.createdAt.toString(), // Format this date as needed
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              );
  }
}