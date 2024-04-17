// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_praktek_akhir/models/foto.dart';
import 'package:tugas_praktek_akhir/widgets/dashboard/home/foto/comments/coment.dart';
import '../../../../api/foto/foto.dart';
import '../../../../api/like_foto/like_foto.dart';
import '../../../../models/like_status.dart';
import '../../../../models/user.dart';
import 'package:http/http.dart' as http;

class ItemFotoScreen extends StatefulWidget {
  final int userId;
  final User user;

  const ItemFotoScreen({super.key, required this.userId, required this.user});

  @override
  State<ItemFotoScreen> createState() => _ItemFotoScreenState();
}

class _ItemFotoScreenState extends State<ItemFotoScreen> {
  late Future<List<Foto>> _futureFotos;
  late Timer _timer;

  void toggleisLikeFoto(Foto foto, int userId) async {
    var likeBox = await Hive.openBox<LikeStatus>('likeBox');
    var likeStatus = likeBox.get(foto.id.toString() + userId.toString());

    if (likeStatus != null && likeStatus.isLiked) {
      foto.like = 0;
      await LikeFotoApi.unlikePhoto(foto.id, userId);
      likeStatus.delete();
    } else {
      foto.like = 1;
      await LikeFotoApi.likePhoto(foto.id, userId);
      likeBox.put(
        foto.id.toString() + userId.toString(),
        LikeStatus(
          userId: userId,
          fotoId: foto.id,
          isLiked: true,
        ),
      );
    }

    setState(() {});
  }

  Future<String> getUsernameFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';
    return username;
  }

  void showModalComment(Foto foto, User user) async {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (BuildContext ctx) => CommentsScreen(
        foto: foto,
        user: user,
      ),
    );
  }

  void deleteFoto(String fotoId) async {
    final response = await http.delete(Uri.parse(
        'https://api-tugas-akhir.vercel.app/api/v1/foto/$fotoId?auth=123'));

    if (response.statusCode == 200) {
      setState(() {});
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Success to delete photo'),
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
            content: const Text('Failed to delete photo'),
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

  bool isCurrentUserOwner(String username) {
    return widget.user.username == username;
  }

  @override
  void initState() {
    super.initState();
    _futureFotos = FotoApi().fetchFoto();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      _futureFotos = FotoApi().fetchFoto();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Foto>>(
      future: _futureFotos,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No photos available'));
        } else {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Wrap(
              children: snapshot.data!.map((foto) {
                final formattedDate =
                    DateFormat.yMMMd().format(foto.tanggalUnggah);
                final isOwner = isCurrentUserOwner(foto.userId.username);
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 419,
                  child: Container(
                    margin: const EdgeInsets.only(top: 15),
                    decoration: const BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.network(
                                foto.lokasiFile,
                                width: MediaQuery.of(context).size.width,
                                height: 250,
                                fit: BoxFit.cover,
                              ),
                            ),
                            if (isOwner) ...[
                              Positioned(
                                right: 0,
                                child: IconButton(
                                  onPressed: () {
                                    deleteFoto(foto.id.toString());
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ]
                          ],
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 9),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Post by:${foto.userId.username}',
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                              Text(
                                foto.judulFoto,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                foto.deskripsiFoto,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 9),
                          child: Row(
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      toggleisLikeFoto(foto, widget.userId);
                                    },
                                    child: FutureBuilder<LikeStatus?>(
                                      future:
                                          Hive.openBox<LikeStatus>('likeBox')
                                              .then((box) => box.get(foto.id
                                                      .toString() +
                                                  widget.userId.toString())),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Icon(
                                            Icons.favorite_border,
                                            color: Colors.white,
                                          );
                                        } else if (snapshot.hasData &&
                                            snapshot.data!.isLiked) {
                                          return const Icon(
                                            Icons.favorite,
                                            color: Colors.pink,
                                          );
                                        } else {
                                          return const Icon(
                                            Icons.favorite_border,
                                            color: Colors.white,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Text(
                                    foto.like.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              IconButton(
                                  onPressed: () {
                                    showModalComment(foto, widget.user);
                                  },
                                  icon: const Icon(
                                    Icons.comment_outlined,
                                    color: Colors.white,
                                  )),
                              const SizedBox(
                                width: 7,
                              ),
                              const Spacer(),
                              Text(
                                formattedDate,
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}
