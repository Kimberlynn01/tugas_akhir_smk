import 'package:flutter/foundation.dart';
import 'package:tugas_praktek_akhir/api/album/album_sort.dart';
import 'package:tugas_praktek_akhir/models/foto.dart';

class FotoProvider with ChangeNotifier {
  final Map<int, List<Foto>> _photosByAlbumId = {};

  Map<int, List<Foto>> get photosByAlbumId => _photosByAlbumId;

  Future<void> fetchAndListenForPhotosByAlbumId(int id) async {
    try {
      FotoApi fotoApi = FotoApi(
          'https://api-tugas-akhir.vercel.app/api/v1/album/$id/photos?auth=123');
      List<Foto> fetchedPhotos = await fotoApi.fetchPhotosByAlbumId();

      _photosByAlbumId[id] = fetchedPhotos;
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching photos for album ID $id: $error');
      }
    }
  }
}
