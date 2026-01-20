
 abstract class SignupState {}
 class SignInitial extends SignupState{}
 class SignLoading extends SignupState{}
 class SignSuccess extends SignupState{}
 class SignFailure extends SignupState{
   final String message;

   SignFailure({required this.message});
 }





