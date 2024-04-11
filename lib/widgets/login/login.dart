// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_praktek_akhir/main.dart';
import 'package:tugas_praktek_akhir/widgets/dashboard/home/home.dart';
import 'package:tugas_praktek_akhir/widgets/login/login/login.dart';
import 'package:http/http.dart' as http;
import 'package:tugas_praktek_akhir/widgets/login/register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _registerRedirect() {
    Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => const Register()));
  }

  void _login() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Failed'),
            content: const Text('Please fill the field '),
            actions: [
              TextButton(
                onPressed: () {},
                child: const Text('Close'),
              )
            ],
          );
        },
      );
    }
    Uri urlApi =
        Uri.parse('https://api-tugas-akhir.vercel.app/api/v1/user?auth=123');
    try {
      http.Response response = await http.get(urlApi);

      if (response.statusCode == 200) {
        List<dynamic> users = jsonDecode(response.body);
        Map<String, dynamic>? userData = users.firstWhere(
          (user) =>
              user['username'] == username && user['password'] == password,
          orElse: () => null,
        );

        if (userData != null) {
          if (kDebugMode) {
            print('Login as $username');
          }
          if (kDebugMode) {
            print('Login Success');
          }
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("username", username);
          await prefs.setInt("userId", userData['userId']);

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (ctx) => const LandingPage()),
              (route) => false);
        } else {
          if (kDebugMode) {
            print('incorrect username or password');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error : $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          String? username = snapshot.data?.getString('username');
          if (username != null && username.isNotEmpty) {
            return const HomeDashboard();
          } else {
            return Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 26),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'Login Account',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        const SizedBox(height: 46),
                        Expanded(
                          child: LoginScreen(
                            usernameController: _usernameController,
                            passwordController: _passwordController,
                          ),
                        ),
                        TextButton(
                          onPressed: _registerRedirect,
                          child: const Text(
                            'Don\'t have any account?',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _login,
                          style: ButtonStyle(
                            shape:
                                MaterialStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            )),
                            backgroundColor:
                                const MaterialStatePropertyAll(Colors.blueGrey),
                            minimumSize: MaterialStatePropertyAll(
                              Size(MediaQuery.of(context).size.width, 55),
                            ),
                          ),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        }
      },
    );
  }
}
