


import '../../../auth/data/user_model.dart';

abstract class CheckoutState {}
         class ChangePaymentMethod extends CheckoutState{
            final String selectMethod;
            ChangePaymentMethod({required this.selectMethod});
         }

       class CheckoutInitial extends CheckoutState{}
         class CheckoutLoading extends CheckoutState{}

        class CheckoutSuccess extends CheckoutState{}

       class CheckoutFailure extends CheckoutState{
           final String? message;

           CheckoutFailure({this.message});
       }

class GetProfileLoading extends CheckoutState {}

class GetProfileSuccess extends CheckoutState {
  final UserModel user;
  GetProfileSuccess(this.user);
}

class GetProfileError extends CheckoutState {
  final String message;
  GetProfileError(this.message);
}