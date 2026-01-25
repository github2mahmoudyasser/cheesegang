import 'package:cheesegang/core/network/api_error.dart';
import 'package:cheesegang/features/auth/data/auth_repo.dart';
import 'package:cheesegang/features/auth/view/sign_screen/logic/signup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


       class SignupCubit extends Cubit<SignupState>{
         final AuthRepo authRepo;
          SignupCubit(this.authRepo):super(SignInitial());

           Future<void> signUp(String name, String email,String password)async{
              emit(SignLoading());
              try{
                final userData =  await authRepo.signUp(name, email, password);
                if(userData!=null) {
                  emit(SignUpSuccess(userModel: userData));
                }
              }catch(e){
                String msg = "Failed, Please try again";
                if(e is ApiError){
                   msg = e.message;
                }else{
                  msg = e.toString();
                }
               emit(SignFailure(message: msg));
              }
           }
       }
