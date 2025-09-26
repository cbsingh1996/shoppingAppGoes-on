// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderHistoryAdapter extends TypeAdapter<OrderHistory> {
  @override
  final int typeId = 4;

  @override
  OrderHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderHistory(
      orderId: fields[0] as String,
      products: (fields[1] as List).cast<Product>(),
      totalAmount: fields[2] as double,
      paymentMode: fields[3] as String,
      status: fields[4] as String,
      orderDate: fields[5] as DateTime,
      deliveryAddress: fields[6] as Address,
      useCoupon: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, OrderHistory obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.orderId)
      ..writeByte(1)
      ..write(obj.products)
      ..writeByte(2)
      ..write(obj.totalAmount)
      ..writeByte(3)
      ..write(obj.paymentMode)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.orderDate)
      ..writeByte(6)
      ..write(obj.deliveryAddress)
      ..writeByte(7)
      ..write(obj.useCoupon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
