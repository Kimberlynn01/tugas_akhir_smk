import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RegisterScreen extends StatefulWidget {
  TextEditingController usernameController;
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController namaLengkapController;
  TextEditingController alamatController;

  RegisterScreen({
    super.key,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.namaLengkapController,
    required this.alamatController,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isVisiblePassword = false;

  void toggleVisiblePassword() {
    setState(() {
      isVisiblePassword = !isVisiblePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Username'),
          const SizedBox(
            height: 5,
          ),
          TextField(
            controller: widget.usernameController,
          ),
          const SizedBox(
            height: 20,
          ),
          const Text('Email'),
          const SizedBox(
            height: 5,
          ),
          TextField(
            keyboardType: TextInputType.emailAddress,
            controller: widget.emailController,
          ),
          const SizedBox(
            height: 20,
          ),
          const Text('Password'),
          const SizedBox(
            height: 5,
          ),
          TextField(
            obscureText: !isVisiblePassword,
            decoration: InputDecoration(
                suffixIcon: IconButton(
              onPressed: toggleVisiblePassword,
              icon: Icon(
                  isVisiblePassword ? Icons.visibility : Icons.visibility_off),
            )),
            keyboardType: TextInputType.visiblePassword,
            controller: widget.passwordController,
          ),
          const SizedBox(
            height: 20,
          ),
          const Text('Nama Lengkap'),
          const SizedBox(
            height: 5,
          ),
          TextField(
            controller: widget.namaLengkapController,
          ),
          const SizedBox(
            height: 20,
          ),
          const Text('Alamat'),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            maxLines: null,
            controller: widget.alamatController,
          ),
          const SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }
}
