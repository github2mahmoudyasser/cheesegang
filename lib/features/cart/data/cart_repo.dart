
      import 'package:cheesegang/core/network/api_error.dart';
import 'package:cheesegang/core/network/api_exception.dart';
import 'package:cheesegang/core/network/api_service.dart';
import 'package:cheesegang/features/cart/data/cart_model.dart';
import 'package:cheesegang/features/checkout/data/checkout_model.dart';
import 'package:cheesegang/features/orderHistory/data/order_model.dart';
import 'package:dio/dio.dart';


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

               return GetCartModel.fromJson(getCartRequest);

            } on DioException catch(e){
               throw ApiExceptions.handleError(e);
            }catch(e){
               throw ApiError(message: e.toString());
            }

          }
          
          // delete from cart
       Future<void> removeCartItem(int id)async{
        try{
          final deleteRequest = await apiService.delete("/cart/remove/$id", {});
          if(deleteRequest["code"]!=200){
            throw ApiError(message: deleteRequest["message"]);
          }
        } on DioException catch(e){
           throw ApiExceptions.handleError(e);
        }catch(e){
          throw ApiError(message: e.toString());
        }
      
       }



   //Save order
   Future<void> checkOut(CartRequestModel orderData )async{
     try{
       final cartRequest = await apiService.post("/orders", orderData.toJson());
       if(cartRequest is ApiError){
         throw cartRequest;
       }
       if(cartRequest is Map<String,dynamic>){
         final msg = cartRequest["message"];
         final code = cartRequest["code"];
         if(code==200||code==201){
           return cartRequest["data"];
         }else{
           throw ApiError(message: msg);
         }

       }
     } on DioException catch(e){
       throw ApiExceptions.handleError(e);
     }catch(e){
       throw ApiError(message: e.toString());
     }

   }


    }

