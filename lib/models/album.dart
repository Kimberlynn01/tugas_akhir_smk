import 'package:tugas_praktek_akhir/models/user.dart';

class Album {
  final int id;
  final String namaAlbum;
  final String deskripsi;
  final String foto;
  final DateTime tanggalDibuat;
  final User userId;

  Album({
    required this.id,
    required this.namaAlbum,
    required this.deskripsi,
    required this.foto,
    required this.tanggalDibuat,
    required this.userId,
  });

  String getShortenedDeskripsi() {
    const maxLength = 23;
    if (deskripsi.length <= maxLength) {
      return deskripsi;
    } else {
      return '${deskripsi.substring(0, maxLength)}...';
    }
  }

  factory Album.fromJson(Map<String, dynamic> json) {
    final String? rawDate = json['tanggalUnggah'];
    final DateTime tanggalDibuat =
        rawDate != null ? DateTime.parse(rawDate) : DateTime.now();

    final dynamic userIdData = json['userId'];
    final int userId = userIdData != null && userIdData['id'] != null
        ? int.tryParse(userIdData['id'].toString()) ?? 0
        : 0;

    return Album(
      id: json['albumId'] ?? 0,
      namaAlbum: json['namaAlbum'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      foto: json['fotoAlbum'] ?? '',
      tanggalDibuat: tanggalDibuat,
      userId: User(
        id: userId,
        username: userIdData != null ? userIdData['username'].toString() : '',
        password: '',
        email: '',
        namaLengkap: '',
        alamat: '',
      ),
    );
  }
}
