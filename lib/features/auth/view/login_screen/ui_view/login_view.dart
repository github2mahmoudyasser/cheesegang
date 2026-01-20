

import 'package:cheesegang/core/constants/app_colors.dart';
import 'package:cheesegang/features/auth/view/login_screen/logic/login_cubit.dart';
import 'package:cheesegang/features/auth/view/sign_screen/ui_view/signup_view.dart';
import 'package:cheesegang/features/Root/view/root.dart';
import 'package:cheesegang/shared/widgets/costum_snakebar.dart';
import 'package:cheesegang/features/auth/widgets/custom_txtfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../shared/widgets/costum_text.dart';
import '../../../widgets/customAuthBottom.dart';
import '../logic/login_state.dart';

   class LoginView  extends StatefulWidget {
    const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
     final emailController = TextEditingController();

     final passController = TextEditingController();

     final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      @override
  void dispose() {
        emailController.dispose();
        passController.dispose();
    super.dispose();
  }

     @override
     Widget build(BuildContext context) {
       return GestureDetector(
         onTap: () => FocusScope.of(context).unfocus(),
         child: Scaffold(
           backgroundColor: AppColors.primary,
           body: SingleChildScrollView(
             child: Padding(
               padding: const EdgeInsets.symmetric(horizontal: 12),
               child: Column(
                 children: [
                   const Gap(100),

                   CustomText(
                     text: "Cheese Gang!",
                     size: 40,
                     weight: FontWeight.bold,
                     color: Colors.white,
                     fontFamily: GoogleFonts.luckiestGuy().fontFamily,
                   ),

                   const CustomText(
                     text: "Welcome Back!",
                     weight: FontWeight.w500,
                     size: 13,
                     color: Colors.white,
                   ),
                   const Gap(20),
                   BlocConsumer<LoginCubit, LoginState>(
                     listener: (context, state) {
                       if (state is LoginSuccess) {
                         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>Root()),
                         );
                       } else if (state is LoginFailure) {
                         ScaffoldMessenger.of(context).showSnackBar(
                             customSnack(state.message));
                       }
                     },
                     builder: (context, state) {
                       return GlassmorphicContainer(
                         width: double.infinity,
                         height: 400,
                         borderRadius: 50,
                         linearGradient: LinearGradient(
                           begin: Alignment.topLeft,
                           end: Alignment.topRight,
                           colors: [
                             Colors.black.withAlpha(77),
                             Colors.black.withAlpha(26),
                           ],
                         ),
                         border: 0,
                         blur: 20,
                         borderGradient: LinearGradient(
                           colors: [
                             Colors.black.withAlpha(77),
                             Colors.black.withAlpha(26),
                           ],
                         ),
                         child: Padding(
                           padding: const EdgeInsets.symmetric(
                               horizontal: 20),
                           child: Form(
                             key: formKey,
                             child: Column(
                               children: [
                                 const Gap(50),

                                 //emailTextField
                                 CustomTextField(
                                   validator: (v){
                                     final value = v?.trim() ?? ""; //   to delete space automatic

                                     if (value.isEmpty) {
                                       return "Please enter your email";
                                     }

                                     //email regex(Regular Expression)
                                     final emailRegExp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

                                     if(!emailRegExp.hasMatch(value)){
                                       return "Invalid email format (name@example.com)";                                       }
                                     return null;
                                   },
                                     hint: "Email",
                                     isPassword: false,
                                     controller: emailController),
                                 const Gap(10),

                                 //passTextField
                                 CustomTextField(
                                   validator: (v){
                                     if(v==null||v.isEmpty){
                                       return "Please enter your password";
                                     }
                                     // Check powerful
                                      final passRegexp  = RegExp(r'^(?=.*[A-Z])(?=.*[0-9]).{8,}$');
                                     if (!passRegexp.hasMatch(v)) {
                                       return "Password must be at least 8 characters, include an uppercase letter and a number";                                       }
                                     return null;

                                   },
                                     hint: "Password",
                                     isPassword: true,
                                     controller: passController),
                                 const Gap(20),

                                 // Login button
                                 state is LoginLoading
                                     ? const CupertinoActivityIndicator(color: Colors.white)
                                     : CustomAuthButton(
                                   onTap: () {
                                     if (formKey.currentState!.validate()) {
                                       context.read<LoginCubit>().login(
                                           emailController.text.trim(),
                                           passController.text.trim()
                                       );
                                     }
                                   },
                                   text: "Login",
                                   color: Colors.white.withAlpha(26),
                                   fontSize: 18,
                                   textColor: Colors.white,
                                 ),
                                 const Gap(10),

                                 //signUp button
                                 CustomAuthButton(
                                   onTap: () {
                                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignupView(),));
                                   },
                                   color: Colors.white.withAlpha(26),
                                   text: "Sign Up",
                                   fontSize: 18,
                                   textColor: Colors.white,
                                 )
                               ],
                             ),
                           ),
                         ),
                       );
                     },
                   ),
                 ],
               ),
             ),
           ),
         ),
       );
     }
}





