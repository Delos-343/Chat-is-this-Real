import 'package:chat_is_this_real_app/auth/auth_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void logout() {
    // call auth service for log out
    final _auth = AuthService();
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chat,\nis this real?",
          style: TextStyle(
            fontWeight: FontWeight.w300,
          ),
        ),
        actions: [
          // logout btn
          IconButton(onPressed: logout, icon: const Icon(Icons.logout_outlined))
        ],
      ),
      drawer: const Drawer(),
    );
  }
}
