// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_praktek_akhir/provider/album/album_sort.dart';
import 'package:tugas_praktek_akhir/widgets/login/login.dart';
import 'firebase_options.dart';
import 'models/like_status.dart';
import 'provider/album/album.dart';
import 'widgets/dashboard/home/home.dart';
import 'widgets/dashboard/profile/profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Hive.initFlutter();
  Hive.registerAdapter(LikeStatusAdapter());

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? username = prefs.getString('username');

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AlbumProvider()),
      ChangeNotifierProvider(create: (_) => FotoProvider()),
    ],
    child: MaterialApp(
      theme: ThemeData(useMaterial3: true).copyWith(
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.black),
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
        ),
      ),
      home: username != null && username.isNotEmpty
          ? const LandingPage()
          : const Login(),
    ),
  ));
}


class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeDashboard(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
