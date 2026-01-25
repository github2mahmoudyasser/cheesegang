

     import 'package:cheesegang/features/auth/data/user_model.dart';

abstract class LoginState{}
     class LoginInitial extends LoginState{}
     class LoginLoading extends LoginState{}
     class LoginSuccess extends LoginState{
          final UserModel userModel;
          LoginSuccess({required this.userModel});
     }

     class LoginFailure extends LoginState{
         final String message;
         LoginFailure({ required this.message});
     }

