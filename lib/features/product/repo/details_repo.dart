
   import 'package:cheesegang/core/network/api_error.dart';
import 'package:cheesegang/core/network/api_exception.dart';
import 'package:cheesegang/core/network/api_service.dart';
import 'package:cheesegang/core/utils/pref_helper.dart';
import 'package:cheesegang/features/product/views/logic/product_details_state.dart';
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
           List<DetailsModel> toppings = (toppingsRequest["data"] as List)
               .map((product) => DetailsModel.fromJson(product))
               .toList();
            
              await PrefHelper.cashedToppings(toppings);
              return toppings;

        }
       return[];

     }on DioException catch(e) {
       // get data from cached if lose internet
       final  cashedToppings = await PrefHelper.getCachedToppings();
       if(cashedToppings.isNotEmpty){
         return cashedToppings;
       }
       throw ApiExceptions.handleError(e);
     }catch(e) {
       final cashedToppings = await PrefHelper.getCachedToppings();
       if (cashedToppings.isNotEmpty) {
         return cashedToppings;
       }
       throw ApiError(message: "Server error, please try again");
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
          List<DetailsModel> options = (optionsRequest["data"] as List)
           .map((e)=>DetailsModel.fromJson(e)).toList();
           return options;
        }
        return [];
      }on DioException catch(e){
        final cashedOptions = await PrefHelper.getCachedToppings();
        if(cashedOptions.isNotEmpty){
          return cashedOptions;
        }
         throw ApiExceptions.handleError(e);
      }catch(e){
        throw ApiError(message: "Server Error, please try again.");


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


