import 'package:chat_is_this_real_app/auth/auth_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // damn this part to hell fr (I took way too long)
  void logout() {
    // call auth service for log out
    final _auth = AuthService();
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Chat, ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 23,
                ),
              ),
              Text(
                " is this real ?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 23,
                ),
              ),
            ],
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
