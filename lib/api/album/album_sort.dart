import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tugas_praktek_akhir/models/foto.dart';

class FotoApi {
  final String apiUrl;

  FotoApi(this.apiUrl);

  Future<List<Foto>> fetchPhotosByAlbumId() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Foto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load photos by album ID');
    }
  }
}
