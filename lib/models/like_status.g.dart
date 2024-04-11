// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LikeStatusAdapter extends TypeAdapter<LikeStatus> {
  @override
  final int typeId = 0;

  @override
  LikeStatus read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LikeStatus(
      userId: fields[0] as int,
      fotoId: fields[1] as int,
      isLiked: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, LikeStatus obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.fotoId)
      ..writeByte(2)
      ..write(obj.isLiked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LikeStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
