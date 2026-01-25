

 import 'package:cheesegang/features/auth/data/auth_repo.dart';
import 'package:cheesegang/features/auth/data/user_model.dart';
import 'package:cheesegang/features/checkout/data/checkout_model.dart';
import 'package:cheesegang/features/checkout/data/checkout_repo.dart';
import 'package:cheesegang/features/checkout/views/logic/checkout_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/api_error.dart';

class CheckoutCubit extends Cubit<CheckoutState>{
  final AuthRepo authRepo;
  final CheckoutRepo checkOutRepo;
  CheckoutCubit(this.authRepo, this.checkOutRepo):super(CheckoutInitial());

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
          userModel = profileData;
          emit(GetProfileSuccess(user: profileData!));

       }catch(e){
         String msg = "Failed to get data";
         if(e is ApiError){
            msg = e.toString();
         }
         emit(GetProfileError(message: msg));
       }
   }

   Future<void> confirmOrder(CheckoutModel orderData)async{
      emit(CheckoutLoading());
      try{
      await checkOutRepo.checkOut(orderData);
         emit(CheckoutSuccess(checkoutModel:orderData));


      }catch(e){
        String msg = "Failed to confirm order";
        if(e is ApiError){
          msg = e.toString();
        }
        emit(CheckoutFailure(message: msg));
      }

   }

}

