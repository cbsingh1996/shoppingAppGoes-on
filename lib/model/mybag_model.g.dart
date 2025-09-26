// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mybag_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MybagAdapter extends TypeAdapter<Mybag> {
  @override
  final int typeId = 3;

  @override
  Mybag read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Mybag(
      productId: fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Mybag obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.productId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MybagAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
