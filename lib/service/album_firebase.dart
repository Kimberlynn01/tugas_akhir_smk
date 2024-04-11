import 'package:firebase_database/firebase_database.dart';
import 'package:tugas_praktek_akhir/models/album.dart';

class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Stream<List<Album>> albumStream(int userId) {
    return _database
        .child('albums')
        .orderByChild('userId/id')
        .equalTo(userId)
        .onValue
        .map((event) {
      final data = event.snapshot.value as Map<String, dynamic>?;
      if (data == null) {
        return <Album>[];
      } else {
        return List<Album>.from(data.values
            .map((e) => Album.fromJson(Map<String, dynamic>.from(e))));
      }
    });
  }
}
