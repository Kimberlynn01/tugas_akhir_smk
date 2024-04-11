import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_praktek_akhir/models/user.dart';
import 'package:tugas_praktek_akhir/widgets/dashboard/profile/foto/tambah_foto.dart';
import 'album/tambah_album.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;

  @override
  void initState() {
    super.initState();
    getUserFromSharedPreferences().then((retrievedUser) {
      setState(() {
        user = retrievedUser;
      });
    });
  }

  Future<User?> getUserFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    String? username = prefs.getString('username');

    if (userId != null && username != null) {
      return User(
          id: userId,
          username: username,
          password: '',
          email: '',
          namaLengkap: '',
          alamat: '');
    } else {
      return null;
    }
  }

  void showDialogBottomModalAlbum() {
    if (user != null) {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) => TambahAlbumScreen(
          user: user!,
        ),
      );
    } else {
      if (kDebugMode) {
        print('error');
      }
    }
  }

  void showDialogBottomModalFoto() {
    if (user != null) {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) => TambahFotoScreen(user: user!),
      );
    } else {
      if (kDebugMode) {
        print('error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    )),
                    backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                    minimumSize: MaterialStateProperty.all(
                      Size(MediaQuery.of(context).size.width, 50),
                    ),
                  ),
                  onPressed: showDialogBottomModalAlbum,
                  child: const Text(
                    'Tambah Album',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    )),
                    backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                    minimumSize: MaterialStateProperty.all(
                      Size(MediaQuery.of(context).size.width, 50),
                    ),
                  ),
                  onPressed: showDialogBottomModalFoto,
                  child: const Text(
                    'Tambah Foto',
                    style: TextStyle(color: Colors.white),
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
