import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class LikeFotoApi {
  static Future<void> likePhoto(int fotoId, int userId) async {
    final url =
        Uri.parse('https://api-tugas-akhir.vercel.app/api/v1/liked?auth=123');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fotoId': fotoId,
          'userId': userId,
        }),
      );

      if (kDebugMode) {
        print('Response Body: ${response.body}');
      }

      if (response.statusCode == 201) {
        if (kDebugMode) {
          print('Like berhasil disimpan');
        }
      } else {
        if (kDebugMode) {
          print('Gagal menyimpan like');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }

  static Future<void> unlikePhoto(int fotoId, int userId) async {
    final url = Uri.parse(
        'https://api-tugas-akhir.vercel.app/api/v1/liked/$fotoId?auth=123');
    try {
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
        }),
      );

      if (kDebugMode) {
        print('Response Body: ${response.body}');
      }

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Unlike berhasil');
        }
      } else {
        if (kDebugMode) {
          print('Gagal membatalkan like');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }
}
