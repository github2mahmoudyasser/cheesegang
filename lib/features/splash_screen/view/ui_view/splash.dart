




import 'package:cheesegang/features/Root/view/root.dart';
import 'package:cheesegang/features/auth/view/login_screen/ui_view/login_view.dart';
import 'package:cheesegang/shared/widgets/costum_snakebar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/widgets/customAuthBottom.dart';
import '../logic/splash_cubit.dart';
import '../logic/splash_state.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});
  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    context.read<SplashCubit>().checkLogin();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<SplashCubit,SplashState>(
          listener:(context,state){
            if(state is UserIsLoggedIn){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Root(),));
            }else if(state is UserUnLoggedIn){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Root(),));
            }else if(state is UserFailure){
              ScaffoldMessenger.of(context).showSnackBar(customSnack("Check, your internet ,or try to login again"));
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Root()),
              );
            }

          },
            builder: (context,state){
            return Stack(
            children: [
            Positioned.fill(
            child: Image.asset("assets/splash/Fresh Burger.jpeg", fit: BoxFit.cover),
            ),
            Positioned(
            bottom: MediaQuery.of(context).size.height * 0.10,
            right: MediaQuery.of(context).size.width * 0.10,
            left: MediaQuery.of(context).size.width * 0.10,
            child: state is SplashLoading
            ? const Center(child: CupertinoActivityIndicator(color: Colors.white))
                :  SizedBox.shrink()
              )
            ]
    );
            }
        )
    );
  }
}








