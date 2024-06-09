import 'package:chat_is_this_real_app/components/chat_bubble.dart';
import 'package:chat_is_this_real_app/components/my_textfield.dart';
import 'package:chat_is_this_real_app/services/auth/auth_service.dart';
import 'package:chat_is_this_real_app/services/chat/chat_service.dart';
import 'package:chat_is_this_real_app/themes/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Text controller for messages
  final TextEditingController _messageController = TextEditingController();

  // Chat + Auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  // Textfield focus
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Add listener to Focus Node
    myFocusNode.addListener(
      () {
        if (myFocusNode.hasFocus) {
          // Wait for keyboard; calculate remaining space in chat + scroll down
          Future.delayed(
            const Duration(milliseconds: 500),
            () => scrollDown(),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // Scroll controller
  final ScrollController _scrollController = ScrollController();

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  // Send msg
  void sendMessage() async {
    // If input is filled
    if (_messageController.text.isNotEmpty) {
      // Send msg
      await _chatService.sendMessage(
          widget.receiverID, _messageController.text);

      // Clear input field after sending
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          centerTitle: true,
          title: Text(
            widget.receiverEmail,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.grey.shade700,
          elevation: 0,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: Column(
          children: [
            // Display all messages
            Expanded(
              child: _buildMessageList(),
            ),

            // Display user input
            _buildUserInput(context),
          ],
        ),
      ),
    );
  }

  // Build msg list
  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID),
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
          controller: _scrollController,
          children: snapshot.data!.docs
              .map(
                (doc) => _buildMessageItem(doc),
              )
              .toList(),
        );
      },
    );
  }

  // Build msg item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // For current user
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    // Position message to right for sender
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(
            message: data["message"],
            isCurrentUser: isCurrentUser,
          ),
        ],
      ),
    );
  }

  // Build msg input
  Widget _buildUserInput(BuildContext context) {
    // Light vs Dark : Send Button
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Row(
        children: [
          // Textfield
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: "Write something...",
              obscureText: false,
              focusNode: myFocusNode,
            ),
          ),

          // Send btn
          Container(
            decoration: const BoxDecoration(
              color: Colors.blueGrey,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage,
              icon: Icon(
                Icons.arrow_circle_right_outlined,
                color: isDarkMode ? Colors.amber : Colors.lightBlueAccent,
              ),
            ),
          )
        ],
      ),
    );
  }
}
