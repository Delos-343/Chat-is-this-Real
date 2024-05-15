import 'package:flutter/material.dart';
import 'package:chat_is_this_real_app/themes/light_mode.dart';
import 'auth/login_or_register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat, is this Real?',
      theme: lightMode,
      home: const LoginOrRegister(),
    );
  }
}
