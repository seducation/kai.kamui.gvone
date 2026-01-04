import 'package:appwrite/models.dart' as models hide User;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'appwrite_service.dart';
import 'auth_service.dart';
import 'widgets/add_pop_up_menu.dart';

class ProfileScreen extends StatefulWidget {
  final String? userId;
  const ProfileScreen({super.key, this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<User?> _userFuture;
  late Future<models.RowList> _profilesFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authService = Provider.of<AuthService>(context, listen: false);
    final appwriteService = Provider.of<AppwriteService>(
      context,
      listen: false,
    );
    _userFuture = authService.getCurrentUser();
    _userFuture.then((user) {
      if (user != null) {
        setState(() {
          _profilesFuture = appwriteService.getUserProfiles(
            ownerId: widget.userId ?? user.id,
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.workspace_premium),
            tooltip: 'Upgrade Plan',
            onPressed: () {
              context.push('/upgrade');
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.push('/settings');
            },
          ),
        ],
      ),
      body: FutureBuilder<User?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go('./signin');
            });
            return const Center(child: Text('Redirecting to sign in...'));
          }

          final user = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 2,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Icon(
                                    Icons.person,
                                    size: 80,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      user.email,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '+1 234 567 890', // Placeholder for phone number
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            user.id,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const CreateRowDialog(),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<models.RowList>(
                    future: _profilesFuture,
                    builder: (context, profileSnapshot) {
                      if (profileSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (profileSnapshot.hasError) {
                        return Center(
                          child: Text('Error: ${profileSnapshot.error}'),
                        );
                      }
                      if (!profileSnapshot.hasData ||
                          profileSnapshot.data!.rows.isEmpty) {
                        return const Center(child: Text('No profiles found.'));
                      }

                      final profiles = profileSnapshot.data!.rows;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: profiles.length,
                        itemBuilder: (context, index) {
                          final profile = profiles[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                profile.data['profileImageUrl'] ?? '',
                              ),
                            ),
                            title: Text(profile.data['name'] ?? 'No Name'),
                            subtitle: Text(profile.data['type'] ?? 'No Type'),
                            onTap: () {
                              context.push('/profile_page/${profile.$id}');
                            },
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'SHOW MORE',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Linked Services',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: ListTile(
                      title: const Text('Mobile No'),
                      trailing: TextButton(
                        onPressed: () {},
                        child: const Text('Link'),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: const Text('Email'),
                      trailing: TextButton(
                        onPressed: () {},
                        child: const Text('Link'),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: const Text('Google Services'),
                      trailing: TextButton(
                        onPressed: () {},
                        child: const Text('Link'),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: const Text('ID Card'),
                      trailing: TextButton(
                        onPressed: () {},
                        child: const Text('Link'),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: const Text('Multifactor Auth Services'),
                      trailing: TextButton(
                        onPressed: () {},
                        child: const Text('Link'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      await authService.signOut();
                      if (context.mounted) {
                        context.go('/signin');
                      }
                    },
                    child: const Text('Sign Out'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
