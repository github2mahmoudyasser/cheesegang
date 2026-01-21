// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GetCartModelAdapter extends TypeAdapter<GetCartModel> {
  @override
  final typeId = 2;

  @override
  GetCartModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GetCartModel(
      code: (fields[0] as num).toInt(),
      message: fields[1] as String,
      cartData: fields[2] as CartData,
    );
  }

  @override
  void write(BinaryWriter writer, GetCartModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.message)
      ..writeByte(2)
      ..write(obj.cartData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GetCartModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CartDataAdapter extends TypeAdapter<CartData> {
  @override
  final typeId = 3;

  @override
  CartData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartData(
      id: (fields[0] as num).toInt(),
      totalPrice: fields[1] as String,
      items: (fields[2] as List).cast<CartItemModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, CartData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.totalPrice)
      ..writeByte(2)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CartItemModelAdapter extends TypeAdapter<CartItemModel> {
  @override
  final typeId = 4;

  @override
  CartItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartItemModel(
      itemId: (fields[0] as num).toInt(),
      productId: (fields[1] as num).toInt(),
      name: fields[2] as String,
      image: fields[3] as String,
      qty: (fields[4] as num).toInt(),
      price: fields[5] as String,
      spicy: fields[6] as String,
      toppings: (fields[7] as List).cast<Toppings>(),
      sideOptions: (fields[8] as List).cast<SideOptions>(),
    );
  }

  @override
  void write(BinaryWriter writer, CartItemModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.itemId)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.qty)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.spicy)
      ..writeByte(7)
      ..write(obj.toppings)
      ..writeByte(8)
      ..write(obj.sideOptions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ToppingsAdapter extends TypeAdapter<Toppings> {
  @override
  final typeId = 5;

  @override
  Toppings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Toppings(
      id: (fields[0] as num).toInt(),
      name: fields[1] as String,
      image: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Toppings obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ToppingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SideOptionsAdapter extends TypeAdapter<SideOptions> {
  @override
  final typeId = 6;

  @override
  SideOptions read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SideOptions(
      id: (fields[0] as num).toInt(),
      name: fields[1] as String,
      image: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SideOptions obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SideOptionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
