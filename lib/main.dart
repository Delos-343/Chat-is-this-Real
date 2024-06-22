import 'package:chat_is_this_real_app/services/auth/auth_gate.dart';
import 'package:chat_is_this_real_app/firebase_options.dart';
import 'package:chat_is_this_real_app/themes/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'YOUR_RECAPTCHA_SITE_KEY',
    androidPackageName: 'com.example.chat_is_this_real_app',
    androidSafetyNetApiKey: 'YOUR_SAFETYNET_API_KEY',
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat, is this Real?',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const AuthGate(),
    );
  }
}
