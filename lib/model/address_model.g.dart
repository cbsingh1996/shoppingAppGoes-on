// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddressAdapter extends TypeAdapter<Address> {
  @override
  final int typeId = 6;

  @override
  Address read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Address(
      id: fields[0] as int,
      country: fields[1] as String,
      fullName: fields[2] as String,
      mobileNumber: fields[3] as String,
      houseNumber: fields[4] as String,
      landmark: fields[5] as String,
      pincode: fields[6] as int,
      town: fields[7] as String,
      city: fields[8] as String,
      state: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Address obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.country)
      ..writeByte(2)
      ..write(obj.fullName)
      ..writeByte(3)
      ..write(obj.mobileNumber)
      ..writeByte(4)
      ..write(obj.houseNumber)
      ..writeByte(5)
      ..write(obj.landmark)
      ..writeByte(6)
      ..write(obj.pincode)
      ..writeByte(7)
      ..write(obj.town)
      ..writeByte(8)
      ..write(obj.city)
      ..writeByte(9)
      ..write(obj.state);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
