// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tugas_praktek_akhir/models/user.dart';
import 'package:tugas_praktek_akhir/widgets/login/login.dart';
import 'package:tugas_praktek_akhir/widgets/login/register/register.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _namaLengkapController = TextEditingController();
  final _alamatController = TextEditingController();

  late bool _succesRegister = false;

  void register() async {
    User user = User(
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      namaLengkap: _namaLengkapController.text.trim(),
      alamat: _alamatController.text.trim(),
    );

    Map<String, String> data =
        user.toJson().map((key, value) => MapEntry(key, value.toString()));

    var response = await http.post(
      Uri.parse('https://api-tugas-akhir.vercel.app/api/v1/user?auth=123'),
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      setState(() {
        _succesRegister = true;
      });
      Future.delayed(
        const Duration(seconds: 5),
        () => Navigator.push(
            context, MaterialPageRoute(builder: (ctx) => const Login())),
      );
    } else {
      if (kDebugMode) {
        print('Register Failed ${response.body}');
      }
      if (kDebugMode) {
        print('$data');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 26,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Register Account',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  if (_succesRegister) ...[
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 15),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 12),
                        decoration: const BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: const Text(
                          'Succes Menambahkan User',
                          style: TextStyle(fontSize: 17, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                  const SizedBox(
                    height: 25,
                  ),
                  Expanded(
                    child: RegisterScreen(
                      usernameController: _usernameController,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      namaLengkapController: _namaLengkapController,
                      alamatController: _alamatController,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: register,
                    style: ButtonStyle(
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      backgroundColor:
                          const MaterialStatePropertyAll(Colors.blueGrey),
                      minimumSize: MaterialStatePropertyAll(
                        Size(MediaQuery.of(context).size.width, 55),
                      ),
                    ),
                    child: const Text(
                      style: TextStyle(color: Colors.white, fontSize: 17),
                      'Sign Up',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
