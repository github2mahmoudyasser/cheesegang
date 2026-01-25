
 import '../../../data/user_model.dart';

abstract class SignupState {}
 class SignInitial extends SignupState{}
 class SignLoading extends SignupState{}
 class SignUpSuccess extends SignupState{
   final UserModel userModel;
   SignUpSuccess({required this.userModel});
 }
 class SignFailure extends SignupState{
   final String message;

   SignFailure({required this.message});
 }





