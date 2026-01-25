
      import 'package:cheesegang/core/network/api_error.dart';
import 'package:cheesegang/core/network/api_exception.dart';
import 'package:cheesegang/core/network/api_service.dart';
import 'package:cheesegang/core/utils/pref_helper.dart';
import 'package:cheesegang/features/cart/data/cart_model.dart';
import 'package:dio/dio.dart';

import '../../product/data/details_model.dart';


  class CartRepo{
   final ApiService apiService;
    CartRepo(this.apiService);

           //getCart
          Future<GetCartModel?> getCartData()async{
            try{
              final getCartRequest = await apiService.get("/cart");
              if(getCartRequest is ApiError){
              throw ApiError(message: getCartRequest.message);
              }
                final cartModel =GetCartModel.fromJson(getCartRequest);
                await PrefHelper.cachedCart(cartModel);
                return cartModel;

            } on DioException catch(e){
              // get data from cached if lose internet;
              final cashedCart = await PrefHelper.getCachedCart();
              if(cashedCart!=null){
                return cashedCart;

              }
               throw ApiExceptions.handleError(e);
            }catch(e){
              final cashedCart = await PrefHelper.getCachedCart();
              if(cashedCart!=null){
                return cashedCart;

              }
               throw ApiError(message: "server Error, please try again");
            }

          }
          
          // delete from cart
       Future<void> removeCartItem(int id)async{
        try{
          final deleteRequest = await apiService.delete("/cart/remove/$id", {});
          if(deleteRequest["code"]!=200){
            throw ApiError(message: deleteRequest["message"]);
          }
          await getCartData();
        } on DioException catch(e){
           throw ApiExceptions.handleError(e);
        }catch(e){
          throw ApiError(message: e.toString());
        }
      
       }






    }

