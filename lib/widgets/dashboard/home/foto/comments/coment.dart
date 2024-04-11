import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tugas_praktek_akhir/models/user.dart';

import '../../../../../models/foto.dart';
import '../../../../../models/komentar_foto.dart';

class CommentsScreen extends StatefulWidget {
  final Foto foto;
  final User user;

  const CommentsScreen({
    super.key,
    required this.foto,
    required this.user,
  });

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  List<KomentarFoto> comments = [];
  TextEditingController commentController = TextEditingController();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      fetchComments(widget.foto.id);
    });
  }

  Future<void> fetchComments(int fotoId) async {
    final response = await http.get(
      Uri.parse(
          'https://api-tugas-akhir.vercel.app/api/v1/komentar/$fotoId?auth=123'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      setState(() {
        comments = data.map((item) => KomentarFoto.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load comments');
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> postComment(String comment) async {
    if (comment.isEmpty) {
      throw Exception('Comment cannot be empty');
    }
    final response = await http.post(
      Uri.parse('https://api-tugas-akhir.vercel.app/api/v1/komentar?auth=123'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'isiKomentar': comment,
        'fotoId': {'id': widget.foto.id, 'judulFoto': widget.foto.judulFoto},
        'userId': {'id': widget.user.id, 'username': widget.user.username},
      }),
    );

    if (response.statusCode == 201) {
      setState(() {
        comments.add(KomentarFoto(
          id: '',
          fotoId: widget.foto,
          userId: widget.user,
          isiKomentar: comment,
          tanggalKomentar: DateTime.now(),
        ));
      });
    } else {
      if (kDebugMode) {
        print('Failed to post comment: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    }
  }

  Future<void> deleteComment(KomentarFoto comment) async {
    final response = await http.delete(
      Uri.parse(
          'https://api-tugas-akhir.vercel.app/api/v1/komentar/${comment.id}?auth=123'),
    );

    if (response.statusCode == 200) {
      setState(() {
        comments.remove(comment);
      });
      if (kDebugMode) {
        print('delete comment: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } else {
      if (kDebugMode) {
        print('Failed to delete comment: ${response.statusCode}');
        print('Response body: ${response.body}');
        print(comment.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: comments.isEmpty
                ? const Center(
                    child: Text("Don't Have Comment"),
                  )
                : ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      final isCommentOwner =
                          comment.userId.username == widget.user.username;
                      return ListTile(
                        title: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: const BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    comment.isiKomentar,
                                  ),
                                  const Spacer(),
                                  if (isCommentOwner) ...[
                                    IconButton(
                                      onPressed: () {
                                        deleteComment(comment);
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              Text(
                                'By ${comment.userId.username}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ButtonStyle(
                      minimumSize: const MaterialStatePropertyAll(Size(60, 60)),
                      backgroundColor:
                          const MaterialStatePropertyAll(Colors.blueGrey),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)))),
                  onPressed: () {
                    final comment = commentController.text.trim();
                    postComment(comment);
                  },
                  child: const Text(
                    'Post',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    commentController.dispose();
    comments.clear();
    _timer.cancel();
    super.dispose();
  }
}
