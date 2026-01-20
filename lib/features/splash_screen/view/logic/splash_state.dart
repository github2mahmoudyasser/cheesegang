

           abstract class SplashState {}
           class SplashInitial extends SplashState{}
           class SplashLoading extends SplashState{}
           class UserIsLoggedIn extends SplashState{}
           class UserUnLoggedIn extends SplashState{}

           class UserFailure extends SplashState{
               final String? message;
                UserFailure({this.message});
           }



