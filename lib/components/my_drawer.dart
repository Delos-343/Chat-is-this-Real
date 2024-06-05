import 'package:chat_is_this_real_app/pages/settings_page.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // Logo
              DrawerHeader(
                child: Center(
                  child: Icon(
                    Icons.message,
                    color: Theme.of(context).colorScheme.primary,
                    size: 40,
                  ),
                ),
              ),
              // Home
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text("H o m e"),
                  leading: Icon(Icons.home_outlined),
                  onTap: () {
                    // Pop the drawer
                    Navigator.pop(context);
                  },
                ),
              ),

              // Settings
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text("S e t t i n g s"),
                  leading: Icon(Icons.settings_outlined),
                  onTap: () {
                    // Pop the drawer
                    Navigator.pop(context);
                    // Navigate to Settings
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsPage(),
                        ));
                  },
                ),
              ),
            ],
          ),

          // Logout
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25),
            child: ListTile(
              title: Text("L o g o u t"),
              leading: Icon(Icons.logout_outlined),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
