

     import 'package:cheesegang/features/auth/data/user_model.dart';

//Inheritance
 //Type Safety   make sure when state is success  user model will come with it


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

