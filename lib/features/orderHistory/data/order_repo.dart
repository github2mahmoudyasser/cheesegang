        
         
         import 'package:cheesegang/core/network/api_error.dart';
import 'package:cheesegang/core/network/api_service.dart';
import 'package:cheesegang/features/orderHistory/data/order_model.dart';

class OrderRepo{
             ApiService apiService = ApiService();
             

           
           
             //get Order
           Future<GetOrderModel?>  getOrderData()async{
             try{
                final getOrderRequest = await apiService.get("/orders");
                if(getOrderRequest is ApiError){
                  throw getOrderRequest;

                }
                  return GetOrderModel.fromJson(getOrderRequest);
               
             }catch(e){
               throw ApiError(message: e.toString());
             }
             
           }
         }