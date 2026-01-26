

import 'dart:core';
import 'package:hive_ce/hive.dart';
part 'product_model.g.dart';

@HiveType(typeId: 0)
 class ProductModel {
@HiveField(0)
  final int id;

@HiveField(1)
  final String name;

@HiveField(2)
  final String desc;

@HiveField(3)
     final String image;

@HiveField(4)
  final String rate;

@HiveField(5)
  final String price;

      ProductModel({
        required this.id,
        required this.name,
        required this.desc,
        required this.image,
        required this.rate,
        required this.price
 });
      factory ProductModel.fromJson(Map<String,dynamic>json){
        String imageUrl = json["image"];
        if(imageUrl.startsWith("http://")){
       imageUrl = imageUrl.replaceFirst("http://", "https://");
        }
        return ProductModel(
            id: json["id"],
            name: json["name"],
            desc: json["description"],
            image: imageUrl,
            rate:json["rating"],
            price: json["price"]
        );

      }


 }

// favouritesModel
class FavouritesModel{
  final int productId;

  FavouritesModel({
    required this.productId
  });
  Map<String,dynamic> toJson()=>{
    "product_id":productId
  };
}





