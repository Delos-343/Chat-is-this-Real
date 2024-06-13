import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          centerTitle: true,
          title: const Text("Profile"),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.blueGrey,
          elevation: 0,
        ),
      ),
    );
  }
}
