import 'package:flutter/material.dart';
import 'package:my_app/appwrite_service.dart';
import 'package:my_app/chat_messaging_screen.dart';
import 'package:my_app/find_account_page_screen.dart';
import 'package:my_app/model/chat_model.dart';
import 'package:my_app/sign_in.dart';
import 'package:provider/provider.dart';
import 'package:appwrite/models.dart' as models;

class SelectContactScreen extends StatefulWidget {
  const SelectContactScreen({super.key, required this.onNewChat});

  final Function(ChatModel) onNewChat;

  @override
  State<SelectContactScreen> createState() => _SelectContactScreenState();
}

class _SelectContactScreenState extends State<SelectContactScreen> {
  late final AppwriteService _appwriteService;
  List<ChatModel> _contacts = [];
  bool _isLoading = true;
  models.User? _currentUser;

  @override
  void initState() {
    super.initState();
    _appwriteService = context.read<AppwriteService>();
    _loadFollowingContacts();
  }

  Future<void> _loadFollowingContacts() async {
    try {
      _currentUser = await _appwriteService.getUser();
      if (!mounted) return;
      final profiles = await _appwriteService.getFollowingProfiles(userId: _currentUser!.$id);
      if (!mounted) return;

      final contactList = profiles.rows
          .map((doc) => ChatModel(
                userId: doc.data['ownerId'], // Correctly use the ownerId for messaging
                name: doc.data['name'] ?? 'No Name',
                message: doc.data['status'] ?? 'No Status',
                time: "",
                imgPath: doc.data['profileImageUrl'] ?? "",
              ))
          .toList();

      setState(() {
        _contacts = contactList;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading contacts: $e")),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleContactTap(ChatModel contact) async {
    try {
      await _appwriteService.getUser(); // Ensure user is still logged in
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChatMessagingScreen(
            chat: contact,
            onMessageSent: (newMessage) {
              final newChat = contact;
              newChat.message = newMessage;
              newChat.time = "Now";
              widget.onNewChat(newChat);
            },
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      // If getUser fails, it means session expired
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Following"),
            if (!_isLoading)
              Text(
                "${_contacts.length} contacts",
                style: TextStyle(
                  fontSize: 13,
                  color: theme.appBarTheme.titleTextStyle?.color?.withAlpha(179),
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FindAccountPageScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                const SizedBox(height: 10),
                // Contact Items
                ..._contacts.map((contact) => ContactItem(
                      contact: contact,
                      onTap: () => _handleContactTap(contact),
                    )),
              ],
            ),
    );
  }
}


// Widget for individual contacts
class ContactItem extends StatelessWidget {
  final ChatModel contact;
  final VoidCallback onTap;

  const ContactItem({super.key, required this.contact, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: Colors.grey[300],
        // Use a placeholder if the image path is empty
        backgroundImage: (contact.imgPath.isNotEmpty && Uri.parse(contact.imgPath).isAbsolute) 
            ? NetworkImage(contact.imgPath)
            : null,
        child: (contact.imgPath.isEmpty || !Uri.parse(contact.imgPath).isAbsolute)
            ? Text(
                contact.name.isNotEmpty ? contact.name[0] : "",
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              )
            : null,
      ),
      title: Row(
        children: [
          Text(
            contact.name,
            style: theme.textTheme.titleMedium,
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 2.0),
        child: Text(
          contact.message, // This should be 'status' from the profile
          style: theme.textTheme.bodySmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
