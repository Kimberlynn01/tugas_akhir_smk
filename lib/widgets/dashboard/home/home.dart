import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_praktek_akhir/models/user.dart';
import 'package:tugas_praktek_akhir/widgets/dashboard/home/foto/foto.dart';
import 'package:tugas_praktek_akhir/widgets/dashboard/logout.dart';
import 'album/item.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  final DatabaseReference _usersRef =
      FirebaseDatabase.instance.ref().child('users');

  String? _username;
  int? _userId;

  Future<void> getUserDataFromDatabase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    int? userId = prefs.getInt("userId");

    if (username != null && userId != null) {
      _usersRef.once().then((DatabaseEvent event) {
        dynamic data = event.snapshot.value;
        if (data is List) {
          for (var user in data) {
            if (user is Map &&
                user['username'] == username &&
                user['userId'] == userId) {
              setState(() {
                _username = user['username'];
                _userId = user['userId'];
              });
              break;
            }
          }
        }
      });
    }
  }

  void _logout() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => const Logout()),
    );
  }

  @override
  void initState() {
    super.initState();
    getUserDataFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('NetWorkHub'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome $_username',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 25),
                  if (_userId != null) ...[
                    const Text(
                      'Archive',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ItemAlbum(
                      userId: _userId!,
                      user: User(
                          id: _userId!,
                          username: _username!,
                          password: '',
                          email: '',
                          namaLengkap: '',
                          alamat: ''),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      color: Colors.black,
                    ),
                    const Text(
                      'Rencents Post',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 5,
                      child: ItemFotoScreen(
                        userId: _userId!,
                        user: User(
                            id: _userId!,
                            username: _username!,
                            password: '',
                            email: '',
                            namaLengkap: '',
                            alamat: ''),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
