
/*
 import 'package:cheesegang/features/auth/data/auth_repo.dart';
import 'package:cheesegang/features/auth/data/user_model.dart';
import 'package:cheesegang/features/auth/view/profile_screen/logic/profile_state.dart';
import 'package:cheesegang/features/checkout/data/checkout_model.dart';
import 'package:cheesegang/features/checkout/data/checkout_repo.dart';
import 'package:cheesegang/features/checkout/views/logic/checkout_state.dart';
import 'package:cheesegang/features/orderHistory/data/order_model.dart';
import 'package:cheesegang/features/orderHistory/data/order_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_error.dart';

class CheckoutCubit extends Cubit<CheckoutState>{
  final AuthRepo authRepo;
  final OrderRepo orderRepo;
  CheckoutCubit(this.authRepo, this.orderRepo):super(CheckoutInitial());

  String selectPayment = "cash";
  UserModel ? userModel;


   void changePayment(String method){
       selectPayment = method;
        emit(ChangePaymentMethod(selectMethod: method));
   }
   Future<void> getProfileData()async{
       emit(GetProfileLoading());
       try{
          final profileData = await authRepo.getProfileData();
          emit(GetProfileSuccess(profileData!));

       }catch(e){
         String msg = "Failed to get data";
         if(e is ApiError){
            msg = e.toString();
         }
         emit(GetProfileError(msg));
       }
   }

   Future<void> confirmOrder(OrderRequestModel orderData)async{
      emit(CheckoutLoading());
      try{
        await orderRepo.saveOrder(orderData);
        emit(CheckoutSuccess());

      }catch(e){
        String msg = "Failed to confirm order";
        if(e is ApiError){
          msg = e.toString();
        }
        emit(CheckoutFailure(message: msg));
      }

   }

}

 */