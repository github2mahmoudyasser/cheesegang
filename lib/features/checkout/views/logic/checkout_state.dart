


    import 'package:cheesegang/features/checkout/data/checkout_model.dart';
import 'package:equatable/equatable.dart';

import '../../../auth/data/user_model.dart';

      abstract class CheckoutState extends Equatable {
        @override
        List<Object?> get props => [];
      }
         class ChangePaymentMethod extends CheckoutState{
            final String selectMethod;
            ChangePaymentMethod({required this.selectMethod});
            @override
            List<Object?> get props => [selectMethod];
         }

       class CheckoutInitial extends CheckoutState{}
         class CheckoutLoading extends CheckoutState{}

        class CheckoutSuccess extends CheckoutState{
        final CheckoutModel checkoutModel;
        CheckoutSuccess({required this.checkoutModel});
        @override
        List<Object?> get props => [checkoutModel];
        }

       class CheckoutFailure extends CheckoutState{
           final String? message;

           CheckoutFailure({this.message});
           @override
           List<Object?> get props => [message];
       }

class GetProfileLoading extends CheckoutState {}

class GetProfileSuccess extends CheckoutState {
  final UserModel user;
  GetProfileSuccess({required this.user});
  @override
  List<Object?> get props => [user];
}

class GetProfileError extends CheckoutState {
  final String? message;
  GetProfileError({this.message});
  @override
  List<Object?> get props => [message];
}