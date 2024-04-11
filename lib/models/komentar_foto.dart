import 'package:tugas_praktek_akhir/models/foto.dart';
import 'package:tugas_praktek_akhir/models/user.dart';

class KomentarFoto {
  final String id;
  final Foto fotoId;
  final User userId;
  final String isiKomentar;
  final DateTime tanggalKomentar;

  KomentarFoto({
    required this.id,
    required this.fotoId,
    required this.userId,
    required this.isiKomentar,
    required this.tanggalKomentar,
  });

  factory KomentarFoto.fromJson(Map<String, dynamic> json) {
    return KomentarFoto(
      id: json['id'],
      fotoId: Foto.fromJson(json['fotoId']),
      userId: User.fromJson(json['userId']),
      isiKomentar: json['isiKomentar'],
      tanggalKomentar: DateTime.parse(json['tanggalKomentar']),
    );
  }
}
