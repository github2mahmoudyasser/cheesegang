
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

// Dry (Don't repeat your self)
  Future<List<DetailsModel>> getExtra(String endPoint)async{
    try{
      final request = await apiService.get(endPoint);
      if(request is ApiError){
        throw request;
      }
      if(request is Map<String,dynamic>){
        final msg = request["message"];
        final code = request["code"];
        if(code!=200&&code!=201){
          throw ApiError(message: msg);
        }
        List<DetailsModel> extras = (request["data"] as List)
            .map((product) => DetailsModel.fromJson(product))
            .toList();

        await PrefHelper.cashedToppings(extras);
        return extras;

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

  //get toppings
  Future<List<DetailsModel>> getToppings()async{
    return getExtra("/toppings");
  }

  //get options
  Future<List<DetailsModel>> getOptions()async{
    return getExtra("/side-options");
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


