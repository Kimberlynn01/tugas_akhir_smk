// ignore_for_file: depend_on_referenced_packages

import 'package:hive/hive.dart';

part 'like_status.g.dart';

@HiveType(typeId: 0)
class LikeStatus extends HiveObject {
  @HiveField(0)
  late int userId;

  @HiveField(1)
  late int fotoId;

  @HiveField(2)
  late bool isLiked;

  LikeStatus(
      {required this.userId, required this.fotoId, this.isLiked = false});
}
