
import 'dart:core';

import 'package:hive_ce/hive.dart';
part 'cart_model.g.dart';

   //Get Cart from Api
@HiveType(typeId: 2)
class GetCartModel extends HiveObject {
  @HiveField(0)
  final int code;
  @HiveField(1)
  final String message;
  @HiveField(2)
  final CartData cartData;

  GetCartModel({
    required this.code,
    required this.message,
    required this.cartData,
  });

  factory GetCartModel.fromJson(Map<String, dynamic> json) {
    return GetCartModel(
      code: json["code"],
      message: json["message"]?.toString() ?? "",
      cartData: CartData.fromJson(json["data"]),
    );
  }
}

@HiveType(typeId: 3)
class CartData extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String totalPrice;
  @HiveField(2)
  final List<CartItemModel> items;

  CartData({
    required this.id,
    required this.totalPrice,
    required this.items,
  });

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
      id: json["id"] ?? 0,
      totalPrice: json["total_price"] ?? "",
      items: (json["items"] as List)
          .map((items) => CartItemModel.fromJson(items))
          .toList(),
    );
  }
}

@HiveType(typeId: 4)
class CartItemModel extends HiveObject {
  @HiveField(0)
  final int itemId;
  @HiveField(1)
  final int productId;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String image;
  @HiveField(4)
  int qty;
  @HiveField(5)
  final String price;
  @HiveField(6)
  String spicy;
  @HiveField(7)
  final List<Toppings> toppings;
  @HiveField(8)
  final List<SideOptions> sideOptions;

  CartItemModel({
    required this.itemId,
    required this.productId,
    required this.name,
    required this.image,
    required this.qty,
    required this.price,
    required this.spicy,
    required this.toppings,
    required this.sideOptions,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    String imageUrl = json["image"] ?? "";
    if (imageUrl.startsWith("http://")) {
      imageUrl = imageUrl.replaceFirst("http://", "https://");
    }
    return CartItemModel(
      itemId: json["item_id"] ?? 0,
      productId: json["product_id"] ?? 0,
      name: json["name"] ?? "",
      image: imageUrl,
      qty: json["quantity"] ?? 0,
      price: json["price"] ?? "",
      spicy: json["spicy"]?.toString() ?? "0.1",
      toppings: (json["toppings"] as List)
          .map((toppings) => Toppings.fromJson(toppings))
          .toList(),
      sideOptions: (json["side_options"] as List)
          .map((toppings) => SideOptions.fromJson(toppings))
          .toList(),
    );
  }
}

@HiveType(typeId: 5)
class Toppings extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String image;

  Toppings({required this.id, required this.name, required this.image});

  factory Toppings.fromJson(Map<String, dynamic> json) {
    return Toppings(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      image: json["image"] ?? "",
    );
  }
}

@HiveType(typeId: 6)
class SideOptions extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String image;

  SideOptions({required this.id, required this.name, required this.image});

  factory SideOptions.fromJson(Map<String, dynamic> json) {
    return SideOptions(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      image: json["image"] ?? "",
    );
  }
}