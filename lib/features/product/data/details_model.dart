


import 'package:hive_ce/hive.dart';
part 'details_model.g.dart'; // to translate data model to 0,1 because hive don't understand normal data but understand 0,1 only

@HiveType(typeId: 1)
 class DetailsModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String image;

  DetailsModel({
    required this.id ,
    required this.name,
    required this.image
});

  factory DetailsModel.fromJson(Map<String,dynamic>json){
    String imageUrl = json["image"];
    if(imageUrl.startsWith("http://")){
      imageUrl = imageUrl.replaceFirst("http://", "https://");
    }
    return DetailsModel(
        id: json["id"],
        name: json["name"],
        image: imageUrl
    );
  }
 }