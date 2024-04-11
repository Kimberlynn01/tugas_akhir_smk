import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tugas_praktek_akhir/models/album.dart';

class AlbumApi {
  final String apiUrl;

  AlbumApi(this.apiUrl);

  Future<List<Album>> fetchAlbums(int userId) async {
    final response = await http.get(Uri.parse('$apiUrl&userId=$userId'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Album.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load albums');
    }
  }
}
