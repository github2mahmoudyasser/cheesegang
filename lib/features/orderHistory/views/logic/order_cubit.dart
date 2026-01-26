


      import 'package:cheesegang/core/utils/pref_helper.dart';
import 'package:cheesegang/features/orderHistory/data/order_model.dart';
import 'package:cheesegang/features/orderHistory/views/logic/order_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/order_repo.dart';

class OrderCubit extends Cubit<OrderState>{
  final OrderRepo orderRepo;
  OrderHisModel ? orderHisModel;
  OrderCubit(this.orderRepo):super(OrderInitial());


   //get orderHis

   Future<void> getOrderHis()async{
    orderHisModel = await PrefHelper.getCachedOrders();
    final token = await PrefHelper.getToken();
    if(token==null || token.isEmpty ||token=="Guest"){
      emit(OrderGuest());
      return;
    }
    emit(OrderLoading());
    try{
      final orderData = await orderRepo.getOrderData();
      if(orderData!=null){
        orderHisModel = orderData;
        emit(OrderSuccess(orderHisModel: orderData));
      }

    } catch (e) {
      if (orderHisModel == null) {
        emit( OrderError(message: "Check your internet connection"));
      } else {
        emit(OrderSuccess(orderHisModel: orderHisModel));
      }
    }


   }

     void deleteOrderHis(int orderId)async{
     if(state is OrderSuccess){
        final currentOrder = (state as OrderSuccess).orderHisModel;  // if state success
       
        currentOrder?.order.removeWhere((item)=>item.id==orderId); // delete order from list by id

        emit(OrderSuccess(orderHisModel:currentOrder)); // sent new state for new data

        PrefHelper.cachedOrderHis(currentOrder!); // save new data in cach
        
        
     }

     }




}