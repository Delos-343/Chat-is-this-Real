import 'package:chat_is_this_real_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    // Light vs Dark : Chat Bubbles
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser
            ? (isDarkMode ? Colors.green.shade700 : Colors.lightBlue)
            : (isDarkMode ? Colors.grey.shade900 : Colors.grey.shade700),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 25,
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
