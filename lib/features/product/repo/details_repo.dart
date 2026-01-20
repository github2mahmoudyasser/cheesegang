
   import 'package:cheesegang/core/network/api_error.dart';
import 'package:cheesegang/core/network/api_exception.dart';
import 'package:cheesegang/core/network/api_service.dart';
import 'package:dio/dio.dart';

import '../../cart/data/cart_model.dart';
import '../data/details_model.dart';

class DetailsRepo {
  final ApiService apiService;
  DetailsRepo(this.apiService);


     //get toppings
   Future<List<DetailsModel>> getToppings()async{
     try{
       final toppingsRequest = await apiService.get("/toppings");
       if(toppingsRequest is ApiError){
         throw toppingsRequest;
       }
        if(toppingsRequest is Map<String,dynamic>){
           final msg = toppingsRequest["message"];
           final code = toppingsRequest["code"];
           if(code!=200&&code!=201){
             throw ApiError(message: msg);
           }
           return (toppingsRequest["data"] as List)
               .map((topping)=>DetailsModel.fromJson(topping))
               .toList();
        }
       return[];

     }on DioException catch(e){
       throw ApiExceptions.handleError(e);
     }catch(e){
      if(e is ApiError) rethrow; // i use rethrow here to throw the same Api message that i throw up in my code //بقلة ارمي نفس الخطا اللي رميتة فوق
        throw ApiError(message: e.toString());  // if i use throw here it will throw bad message
     }


   }

   // side options
  Future<List<DetailsModel>> getSideOptions()async{
      try {
        final optionsRequest = await apiService.get("/side-options");
        if(optionsRequest is ApiError){
          throw optionsRequest;
        }
        if(optionsRequest is Map<String,dynamic>){
           final msg = optionsRequest["message"];
           final code = optionsRequest["code"];

           if(code!=200&&code!=201){
             throw ApiError(message: msg);
           }
           return
             (optionsRequest["data"] as List)
        .map((options)=>DetailsModel.fromJson(options))
               .toList();
        }
        return [];
      }on DioException catch(e){
         throw ApiExceptions.handleError(e);
      }catch(e){
        if(e is ApiError) rethrow;
        throw ApiError(message: e.toString());

      }
  }

  //Add to cart
  Future<void> addToCart(CartRequestModel cartData)async{
    try{
      final cartRequest = await apiService.post("/cart/add", cartData.toJson());
      if(cartRequest is ApiError){
        throw cartRequest;
      }
    } on DioException catch(e){
      throw ApiExceptions.handleError(e);
    }catch(e){
      throw ApiError(message: e.toString());
    }
  }

}


