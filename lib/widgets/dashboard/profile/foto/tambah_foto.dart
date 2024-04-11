// ignore_for_file: avoid_init_to_null, depend_on_referenced_packages, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../models/album.dart';
import '../../../../models/user.dart';

class TambahFotoScreen extends StatefulWidget {
  final User user;
  const TambahFotoScreen({super.key, required this.user});

  @override
  State<TambahFotoScreen> createState() => _TambahFotoScreenState();
}

class _TambahFotoScreenState extends State<TambahFotoScreen> {
  final judulFotoController = TextEditingController();
  final deskripsiFotoController = TextEditingController();
  late File? selectedFile;
  late Album? selectedAlbum = null;
  List<Album> albums = [];
  int lastPhotoId = 0;

  @override
  void initState() {
    super.initState();
    fetchLastPhotoId();
    fetchAlbums();
  }

  Future<void> fetchLastPhotoId() async {
    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref().child('lastPhotoId');
    DatabaseEvent snapshot = await dbRef.once();
    if (snapshot.snapshot.value != null) {
      setState(() {
        lastPhotoId = snapshot.snapshot.value as int;
      });
    }
  }

  Future<void> fetchAlbums() async {
    final response = await http.get(
        Uri.parse('https://api-tugas-akhir.vercel.app/api/v1/album?auth=123'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      List<Album> userAlbums = data
          .where((albumJson) => albumJson['userId']['id'] == widget.user.id)
          .map((albumJson) => Album.fromJson(albumJson))
          .toList();

      setState(() {
        albums = userAlbums;
      });
    } else {
      throw Exception('Failed to fetch albums');
    }
  }

  Future<void> uploadAndSavePhoto(File photoFile, String judulFoto,
      String deskripsiFoto, int userId) async {
    if (selectedAlbum != null) {
      String photoUrl = await uploadPhotoToStorage(photoFile);
      await savePhotoToDatabase(photoUrl, judulFoto, deskripsiFoto, userId);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please select an album.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<String> uploadPhotoToStorage(File photoFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('foto').child(fileName);
    UploadTask uploadTask = ref.putFile(photoFile);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> savePhotoToDatabase(String photoUrl, String judulFoto,
      String deskripsiFoto, int userId) async {
    DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref().child('foto');
    lastPhotoId++;

    Map<String, dynamic> photoData = {
      'fotoId': lastPhotoId,
      'albumId': {
        "id": selectedAlbum?.id ?? "",
        "namaAlbum": selectedAlbum?.namaAlbum ?? "",
      },
      'deskripsiFoto': deskripsiFoto,
      'isLiked': 0,
      'judulFoto': judulFoto,
      'lokasiFile': photoUrl,
      'tanggalUnggah': DateTime.now().toIso8601String(),
      'userId': {
        "id": widget.user.id,
        "username": widget.user.username,
      },
    };

    await databaseRef.child(lastPhotoId.toString()).set(photoData);

    // Simpan kembali ID terakhir ke Firebase Database
    await saveLastPhotoId(lastPhotoId);

    Navigator.pop(context);
  }

  Future<void> saveLastPhotoId(int id) async {
    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref().child('lastPhotoId');
    await dbRef.set(id);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
            child: Column(
              children: [
                const Text(
                  'Tambah Foto',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Judul Foto'),
                    TextField(
                      controller: judulFotoController,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blueGrey),
                        minimumSize: MaterialStateProperty.all(
                          Size(MediaQuery.of(context).size.width, 55),
                        ),
                      ),
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles();
                        if (result != null) {
                          setState(() {
                            selectedFile = File(result.files.first.path!);
                          });
                        }
                      },
                      child: const Text(
                        'Pilih Foto',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text('Deskripsi Foto'),
                    TextFormField(
                      maxLines: null,
                      controller: deskripsiFotoController,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    DropdownButton<Album>(
                      value: selectedAlbum,
                      hint: const Text('Pilih Album'),
                      onChanged: (Album? newValue) {
                        setState(() {
                          selectedAlbum = newValue;
                        });
                      },
                      items: albums.map((Album album) {
                        return DropdownMenuItem<Album>(
                          value: album,
                          child: Text(album.namaAlbum),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blueGrey),
                        minimumSize: MaterialStateProperty.all(
                          Size(MediaQuery.of(context).size.width, 55),
                        ),
                      ),
                      onPressed: () {
                        if (selectedFile != null && selectedAlbum != null) {
                          uploadAndSavePhoto(
                            selectedFile!,
                            judulFotoController.text,
                            deskripsiFotoController.text,
                            widget.user.id,
                          );
                        } else {
                          // Show error message or handle empty file selection
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: const Text(
                                    'Please select a photo and an album.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: const Text(
                        'Simpan Foto',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
