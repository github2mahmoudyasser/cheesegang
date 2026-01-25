

 import 'package:cheesegang/core/network/api_service.dart';
import 'package:cheesegang/features/checkout/data/checkout_model.dart';
import 'package:dio/dio.dart';

import '../../../core/network/api_error.dart';
import '../../../core/network/api_exception.dart';

class CheckoutRepo {
    ApiService apiService;
    CheckoutRepo({required this.apiService});

    //Check out
     Future<void> checkOut(CheckoutModel orderData )async{
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


