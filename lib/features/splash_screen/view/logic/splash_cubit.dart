


    import 'package:cheesegang/core/network/api_error.dart';
import 'package:cheesegang/features/auth/data/auth_repo.dart';
import 'package:cheesegang/features/splash_screen/view/logic/splash_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashCubit extends Cubit<SplashState>{
   final AuthRepo authRepo;
   SplashCubit(this.authRepo):super (SplashInitial());


     Future<void> checkLogin()async{
       emit(SplashLoading());
        try{
         // user state
           final userState = await authRepo.autoLogin();
           if(userState !=null){
             emit(UserIsLoggedIn());
           }else{
             await authRepo.logOut();
             emit(UserUnLoggedIn());
           }
        }catch(e){
         String msg ="Please go to Login";
          if(e is ApiError){
            msg = e.message;
          }else{
            msg = e.toString();
          }
          emit(UserFailure(message: msg));

        }
     }
}



