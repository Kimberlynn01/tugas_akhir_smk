import 'album.dart';
import 'user.dart';

class Foto {
  final int id;
  final String judulFoto;
  final String deskripsiFoto;
  final DateTime tanggalUnggah;
  final String lokasiFile;
  final Album albumId;
  final User userId;
  int like;

  Foto({
    required this.id,
    required this.judulFoto,
    required this.deskripsiFoto,
    required this.tanggalUnggah,
    required this.lokasiFile,
    required this.albumId,
    required this.userId,
    required this.like,
  });

  factory Foto.fromJson(Map<String, dynamic> json) {
    return Foto(
      id: json['fotoId'] as int? ?? 0,
      judulFoto: json['judulFoto'] ?? '',
      deskripsiFoto: json['deskripsiFoto'] ?? '',
      tanggalUnggah: _parseDate(json['tanggalUnggah']),
      lokasiFile: json['lokasiFile'] ?? '',
      like: json['isLiked'] as int? ?? 0,
      albumId: Album.fromJson(json['albumId'] ?? {}),
      userId: User.fromJson(json['userId'] ?? {}),
    );
  }

  static DateTime _parseDate(dynamic dateString) {
    if (dateString == null) {
      return DateTime.now();
    }
    if (dateString is String) {
      return DateTime.parse(dateString.replaceAll('Z', ''));
    }
    throw Exception('Invalid date format');
  }
}
