import 'dart:async';
import 'dart:convert';
import '../../models/foto.dart';
import 'package:http/http.dart' as http;

class FotoApi {
  Future<List<Foto>> fetchFoto() async {
    final response = await http.get(
        Uri.parse('https://api-tugas-akhir.vercel.app/api/v1/foto?auth=123'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Foto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load foto ${response.body}');
    }
  }
}
