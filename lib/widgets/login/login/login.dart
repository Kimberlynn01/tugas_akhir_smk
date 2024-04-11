import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LoginScreen extends StatefulWidget {
  TextEditingController usernameController;
  TextEditingController passwordController;
  LoginScreen(
      {super.key,
      required this.usernameController,
      required this.passwordController});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Username'),
        const SizedBox(height: 5),
        TextField(controller: widget.usernameController),
        const SizedBox(
          height: 25,
        ),
        const Text('Password'),
        const SizedBox(height: 5),
        TextField(controller: widget.passwordController),
      ],
    );
  }
}
