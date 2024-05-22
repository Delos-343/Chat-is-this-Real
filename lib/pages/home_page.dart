import 'package:chat_is_this_real_app/auth/auth_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // damn this to the seven hells fr (way longer than it needed to be)
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Chat, ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 21,
                ),
              ),
              Text(
                " is this (Real) ?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
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
