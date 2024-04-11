import 'package:tugas_praktek_akhir/models/foto.dart';
import 'package:tugas_praktek_akhir/models/user.dart';

class LikeFoto {
  final int id;
  final Foto fotoId;
  final User userId;
  final DateTime tanggalLike;

  LikeFoto({
    required this.id,
    required this.fotoId,
    required this.userId,
    required this.tanggalLike,
  });

  factory LikeFoto.fromJson(Map<String, dynamic> json) {
    return LikeFoto(
      id: json['id'],
      fotoId: json['fotoId'],
      userId: json['userId'],
      tanggalLike: json['tanggalLike'],
    );
  }
}
