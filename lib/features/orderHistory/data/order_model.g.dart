// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderHisModelAdapter extends TypeAdapter<OrderHisModel> {
  @override
  final typeId = 8;

  @override
  OrderHisModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderHisModel(
      code: (fields[0] as num).toInt(),
      message: fields[1] as String,
      order: (fields[2] as List).cast<OrderData>(),
    );
  }

  @override
  void write(BinaryWriter writer, OrderHisModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.message)
      ..writeByte(2)
      ..write(obj.order);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderHisModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OrderDataAdapter extends TypeAdapter<OrderData> {
  @override
  final typeId = 9;

  @override
  OrderData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderData(
      id: (fields[0] as num).toInt(),
      status: fields[1] as String,
      totalPrice: fields[2] as String,
      createdAt: fields[3] as String,
      productImage: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, OrderData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.totalPrice)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.productImage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
