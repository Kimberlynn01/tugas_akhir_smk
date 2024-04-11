import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tugas_praktek_akhir/models/foto.dart';

import '../../../../api/like_foto/like_foto.dart';
import '../../../../models/like_status.dart';
import '../../../../models/user.dart';
import '../../../../provider/album/album_sort.dart';
import '../foto/comments/coment.dart';

class AlbumDetailsFoto extends StatefulWidget {
  final int albumId;
  final int userId;
  final User user;

  const AlbumDetailsFoto(
      {super.key,
      required this.albumId,
      required this.userId,
      required this.user});

  @override
  State<AlbumDetailsFoto> createState() => _AlbumDetailsFotoState();
}

class _AlbumDetailsFotoState extends State<AlbumDetailsFoto> {
  late Timer _timer;

  void toggleisLikeFoto(Foto foto, int userId) async {
    var likeBox = await Hive.openBox<LikeStatus>('likeBox');
    var likeStatus = likeBox.get(foto.id.toString() + userId.toString());

    if (likeStatus != null && likeStatus.isLiked) {
      foto.like = 0;
      await LikeFotoApi.unlikePhoto(foto.id, userId);
      likeStatus.delete();
    } else {
      // Sukai foto
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

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (_) {
        Provider.of<FotoProvider>(context, listen: false)
            .fetchAndListenForPhotosByAlbumId(widget.albumId);
      },
    );
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

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Foto> photos =
        Provider.of<FotoProvider>(context).photosByAlbumId[widget.albumId] ??
            [];
    if (photos.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Foto'),
        ),
        body: Center(
          child: Text(
            'Foto tidak ada : ${widget.albumId}',
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Foto'),
      ),
      body: ListView.builder(
        itemCount: photos.length,
        itemBuilder: (context, index) {
          final formattedDate =
              DateFormat.yMMMd().format(photos[index].tanggalUnggah);
          final photo = photos[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            width: MediaQuery.of(context).size.width,
            height: 405,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Colors.blueGrey),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    photo.lokasiFile,
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 11,
                        horizontal: 13,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            photo.judulFoto,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            photo.deskripsiFoto,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            toggleisLikeFoto(photo, widget.userId);
                          },
                          icon: FutureBuilder<LikeStatus?>(
                            future: Hive.openBox<LikeStatus>('likeBox').then(
                                (box) => box.get(photo.id.toString() +
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
                        IconButton(
                            onPressed: () {
                              showModalComment(photo, widget.user);
                            },
                            icon: const Icon(
                              Icons.comment_outlined,
                              color: Colors.white,
                            )),
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
                    const SizedBox(),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
