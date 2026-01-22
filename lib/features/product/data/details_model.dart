


import 'package:hive_ce/hive.dart';
part 'details_model.g.dart'; // to translate data model to 0,1 because hive don't understand normal data but understand 0,1 only


//Add To Cart to Api
class SandwichModel{
  final int productId;
  final   int qty;
  final  double? spicy;
  final   List<int>? toppings;
  final List<int>? options;


  SandwichModel({
    required this.productId,
    required this.qty,
    this.spicy,
    this.toppings,
    this.options

  });
  Map<String,dynamic>toJson()=>{
    "product_id":productId,
    "quantity":qty,
    "spicy":spicy??0.0,
    "toppings":toppings??[],
    "side_options":options??[],


  };


}
class CartRequestModel{
  final  List<SandwichModel> items;

  CartRequestModel({
    required this.items
  });


  Map<String,dynamic>toJson()=>{
    "items":items.map((items)=>items.toJson()).toList()
  };
}


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