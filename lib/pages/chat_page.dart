import 'package:chat_is_this_real_app/services/auth/auth_service.dart';
import 'package:chat_is_this_real_app/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail;
  final String receiverID;

  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  // Text controller for messages
  final TextEditingController _messageController = TextEditingController();

  // Chat + Auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  // Send msg
  void sendMessage() async {
    // If input is filled
    if (_messageController.text.isNotEmpty) {
      // Send msg
      await _chatService.sendMessage(receiverID, _messageController.text);

      // Clear input field after sending
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receiverEmail),
      ),
      body: Column(
        children: [
          // Display all messages
          Expanded(
            child: _buildMessageList(),
          ),

          // Display user input
        ],
      ),
    );
  }

  // Build msg list
  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(receiverID, senderID),
      builder: (context, snapshot) {
        // Error handling
        if (snapshot.hasError) {
          return const Text("Error getting messages.");
        }

        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading . . .");
        }

        // Return list view
        return ListView(
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  // Build msg item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Text(data["message"]);
  }
}
