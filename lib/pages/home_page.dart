import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void logout() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome Home"),
        actions: [
          // logout btn
          IconButton(onPressed: logout, icon: Icon(Icons.logout_outlined))
        ],
      ),
    );
  }
}
