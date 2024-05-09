import 'package:flutter/material.dart';
import 'package:chat_is_this_real_app/components/my_textfield.dart';
import 'package:chat_is_this_real_app/components/my_button.dart';

class RegisterPage extends StatelessWidget {

    final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  RegisterPage({super.key});

  void register(){}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Login
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),

            const SizedBox(height: 50),
      
            // Welcome Back Msg
            Text(
              'Welcome back, broski!',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 25),
      
            // Email
            MyTextField(
              hintText: "Email",
              obscureText: false,
              controller: _emailController,
            ),

            const SizedBox(height: 10),
      
            // Password
            MyTextField(
              hintText: "Password",
              obscureText: true,
              controller: _pwController,
            ),

            const SizedBox(height: 25),
      
            // Login Btn
            MyButton(
              text: "Register",
              onTap: register,
            ),

            const SizedBox(height: 25),
          
            // Register
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Not a member? ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary
                  ),
                ),
                Text(
                  "Register now.",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}