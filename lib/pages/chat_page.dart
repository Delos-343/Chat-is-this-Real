import 'package:chat_is_this_real_app/services/auth/auth_service.dart';
import 'package:chat_is_this_real_app/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail;

  const ChatPage({
    super.key,
    required this.receiverEmail,
  });

  // Text controller for messages
  final TextEditingController _messageController = TextEditingController();

  // Chat + Auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receiverEmail),
      ),
    );
  }
}
