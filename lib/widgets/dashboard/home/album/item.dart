// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tugas_praktek_akhir/models/user.dart';
import 'package:tugas_praktek_akhir/widgets/dashboard/home/album/details.dart';

import '../../../../models/album.dart';
import '../../../../provider/album/album.dart';
import 'package:http/http.dart' as http;

class ItemAlbum extends StatefulWidget {
  final int userId;
  final User user;

  const ItemAlbum({required this.userId, super.key, required this.user});

  @override
  State<ItemAlbum> createState() => _ItemAlbumState();
}

class _ItemAlbumState extends State<ItemAlbum> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      Provider.of<AlbumProvider>(context, listen: false)
          .fetchDataWithApi(widget.userId);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _deleteAlbum(String albumId) async {
    final response = await http.delete(Uri.parse(
        'https://api-tugas-akhir.vercel.app/api/v1/album/$albumId?auth=123'));

    if (response.statusCode == 200) {
      setState(() {});
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Success to delete album'),
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
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to delete album'),
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 219,
      width: MediaQuery.of(context).size.width,
      child: Consumer<AlbumProvider>(
        builder: (context, albumProvider, _) {
          List<Album> userAlbums = albumProvider.albums
              .where((album) => album.userId.id == widget.userId)
              .toList();

          if (userAlbums.isEmpty) {
            return const Center(
                child: Text(
              'don\'t have albums',
              style: TextStyle(fontSize: 20),
            ));
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: userAlbums.length,
            itemBuilder: (context, index) {
              final album = userAlbums[index];
              final formattedDate =
                  DateFormat.yMMMd().format(album.tanggalDibuat);
              return GestureDetector(
                onLongPress: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext ctx) {
                        return AlertDialog(
                          title: const Text('Confirmation'),
                          content:
                              const Text("confirm, want to delete the album?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                _deleteAlbum(album.id.toString());
                                Navigator.pop(context);
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        );
                      });
                },
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => AlbumDetailsFoto(
                        albumId: album.id,
                        userId: widget.userId,
                        user: User(
                            id: widget.userId,
                            username: widget.user.username,
                            password: '',
                            email: '',
                            namaLengkap: '',
                            alamat: ''),
                      ),
                    ),
                  );
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 60,
                  child: Container(
                    margin: const EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      image: DecorationImage(
                        image: Image.network(
                          album.foto,
                          width: MediaQuery.of(context).size.width,
                          height: 0,
                          fit: BoxFit.cover,
                        ).image,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.5), BlendMode.darken),
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 11, horizontal: 9),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            album.namaAlbum,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Text(
                                album.getShortenedDeskripsi(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                formattedDate,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
