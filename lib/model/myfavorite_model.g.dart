// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'myfavorite_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyfavoriteAdapter extends TypeAdapter<Myfavorite> {
  @override
  final int typeId = 2;

  @override
  Myfavorite read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Myfavorite(
      productId: fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Myfavorite obj) {
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
      other is MyfavoriteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
