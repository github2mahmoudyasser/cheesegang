
import 'dart:core';

      //Add To Cart to Api

class CartModel{
  final int productId;
  final   int qty;
  final  double? spicy;
  final   List<int>? toppings;
  final List<int>? options;


  CartModel({
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
  final  List<CartModel> items;

  CartRequestModel({
    required this.items
  });


  Map<String,dynamic>toJson()=>{
    "items":items.map((items)=>items.toJson()).toList()
  };
}



   //Get Cart from Api
    class GetCartModel{
     final int code;
     final String message;
     final CartData cartData;

      GetCartModel({
       required this.code,
       required this.message ,
       required this.cartData
    });
      factory GetCartModel.fromJson(Map<String,dynamic>json){
        return GetCartModel(
            code: json["code"],
            message: json["message"]?.toString()??"",
            cartData: CartData.fromJson(json["data"]));
      }
    }

    class CartData{
        final int id;
        final String totalPrice;
        final List<CartItemModel> items;

         CartData({
        required this.id,
        required this.totalPrice,
        required this.items
    });
          factory CartData.fromJson(Map<String,dynamic>json){
            return CartData(
                id: json["id"]??0,
                totalPrice: json["total_price"]??"",
                items: (json["items"] as List).map((items)=>CartItemModel.fromJson(items))
                    .toList()
            );

          }


    }

      class CartItemModel{
         final int itemId;
         final int productId;
         final String name;
         final String image;
           int qty;
         final String price;
           String spicy;
         final List<Toppings> toppings;
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
           required this.sideOptions
      });
          factory CartItemModel.fromJson(Map<String,dynamic>json){
            String imageUrl = json["image"];
            if(imageUrl.startsWith("http://")) {
              imageUrl = imageUrl.replaceFirst("http://", "https://");
            }
              return CartItemModel(
                  itemId: json["item_id"]??0,
                  productId: json["product_id"]??0,
                  name: json["name"]??"",
                  image: imageUrl,
                  qty: json["quantity"]??0,
                  price: json["price"]??"",
                spicy: json["spicy"]?.toString() ?? "0.1",
                toppings: (json["toppings"] as List)
                    .map((toppings)=>Toppings.fromJson(toppings))
                    .toList(),
                sideOptions: (json["side_options"] as List)
                    .map((toppings)=>SideOptions.fromJson(toppings))
                    .toList(),
              );
          }


      }
    class Toppings {
  final int id;
  final String name;
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

class SideOptions{
  final int id;
  final String name;
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
