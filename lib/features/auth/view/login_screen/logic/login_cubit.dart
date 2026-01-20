
import 'package:cheesegang/core/network/api_error.dart';
import 'package:cheesegang/features/auth/view/login_screen/logic/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/auth_repo.dart';



    class LoginCubit  extends Cubit<LoginState>{
               final AuthRepo authRepo;
               LoginCubit(this.authRepo) :super(LoginInitial());


                 Future<void> login(String email, String password)async{
                   emit(LoginLoading());
                   try{
                     final userData = await authRepo.login(email, password);
                     if(userData!=null) {
                       emit(LoginSuccess());
                     }
                   }catch(e){
                     String msg = "Failed To Login";
                      if(e is ApiError){
                        msg  = e.message;
                      }else{
                        msg = e.toString();
                      }
                      emit(LoginFailure(message: msg));
                   }
                 }
             }


