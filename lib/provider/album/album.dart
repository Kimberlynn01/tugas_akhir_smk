import 'package:flutter/foundation.dart';
import 'package:tugas_praktek_akhir/models/album.dart';

import '../../api/album/album.dart';

class AlbumProvider with ChangeNotifier {
  List<Album> _albums = [];

  List<Album> get albums => _albums;

  set albums(List<Album> value) {
    _albums = value;
    notifyListeners();
  }

  Future<void> fetchDataWithApi(int userId) async {
    try {
      AlbumApi albumApi =
          AlbumApi('https://api-tugas-akhir.vercel.app/api/v1/album?auth=123');
      List<Album> fetchedAlbums = await albumApi.fetchAlbums(userId);
      albums = fetchedAlbums;
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching albums: $error');
      }
    }
  }
}
