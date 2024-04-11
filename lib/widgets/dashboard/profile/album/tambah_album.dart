// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../models/user.dart';

class TambahAlbumScreen extends StatefulWidget {
  final User user;
  const TambahAlbumScreen({super.key, required this.user});

  @override
  State<TambahAlbumScreen> createState() => _TambahAlbumScreenState();
}

class _TambahAlbumScreenState extends State<TambahAlbumScreen> {
  final deskripsiController = TextEditingController();
  final namaAlbumController = TextEditingController();
  File? fotoAlbum;
  int nextAlbumId = 1;

  Future<void> saveAlbumToFirebase() async {
    if (fotoAlbum == null) {
      return;
    }
    try {
      final firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('album_images/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = firebaseStorageRef.putFile(fotoAlbum!);
      await uploadTask;

      final url = await firebaseStorageRef.getDownloadURL();

      final databaseRef = FirebaseDatabase.instance.ref().child('album');
      databaseRef.push().set({
        'albumId': nextAlbumId.toInt(),
        'deskripsi': deskripsiController.text,
        'fotoAlbum': url,
        'namaAlbum': namaAlbumController.text,
        'tanggalUnggah': DateTime.now().toIso8601String(),
        'userId': {
          'id': widget.user.id,
          'username': widget.user.username,
        },
      });
      nextAlbumId++;
      Navigator.pop(context);
    } catch (error) {
      if (kDebugMode) {
        print('Error saving album: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Column(
              children: [
                const Text(
                  'Tambah Album',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Nama Album'),
                    TextField(
                      controller: namaAlbumController,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text('Deskripsi'),
                    TextFormField(
                      maxLines: 2,
                      maxLength: 23,
                      controller: deskripsiController,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              const MaterialStatePropertyAll(Colors.blueGrey),
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          minimumSize: MaterialStatePropertyAll(
                              Size(MediaQuery.of(context).size.width, 55))),
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles();
                        if (result != null) {
                          setState(() {
                            fotoAlbum = File(result.files.first.path!);
                          });
                        }
                      },
                      child: const Text(
                        'Pilih Gambar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blueGrey),
                        minimumSize: MaterialStateProperty.all(
                          Size(MediaQuery.of(context).size.width, 60),
                        ),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        )),
                      ),
                      onPressed: saveAlbumToFirebase,
                      child: const Text(
                        'Simpan Album',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
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
