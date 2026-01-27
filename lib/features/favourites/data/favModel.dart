


import 'package:hive_ce/hive.dart';
part 'favModel.g.dart';

@HiveType(typeId: 10)
class FavModel{
 @HiveField(0)
  final int id;

 @HiveField(1)
 final String name;

 @HiveField(2)
 final String desc;

 @HiveField(3)
 final String image;

 @HiveField(4)
 final String rating;

 @HiveField(5)
 final String price;

 @HiveField(6)
 final bool isFav;

 FavModel({
   required this.id,
   required this.name,
   required this.desc,
   required this.image,
   required this.rating,
   required this.price,
   required this.isFav
});
  factory FavModel.fromJson(Map<String,dynamic>json){
     return FavModel(
         id: json["id"],
         name: json["name"],
         desc: json["description"],
         image: json["image"],
         rating: json["rating"],
         price: json["price"],
         isFav: json["is_favorite"]
     );
  }

}