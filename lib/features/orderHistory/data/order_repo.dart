        
         
         import 'package:cheesegang/core/network/api_error.dart';
import 'package:cheesegang/core/network/api_service.dart';
import 'package:cheesegang/features/orderHistory/data/order_model.dart';

               class OrderRepo{
             ApiService apiService;
             OrderRepo(this.apiService);

             //get Order
           Future<OrderHisModel?>  getOrderData()async{
             try{
                final getOrderRequest = await apiService.get("/orders");
                if(getOrderRequest is ApiError){
                  throw getOrderRequest;

                }
                  return OrderHisModel.fromJson(getOrderRequest);
               
             }catch(e){
               throw ApiError(message: e.toString());
             }
             
           }
         }