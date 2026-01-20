

import 'package:cheesegang/core/constants/app_colors.dart';
import 'package:cheesegang/features/auth/view/login_screen/ui_view/login_view.dart';
import 'package:cheesegang/shared/widgets/costum_snakebar.dart';
import 'package:cheesegang/features/auth/widgets/custom_txtfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../Root/view/root.dart';
import '../../../../../shared/widgets/costum_text.dart';
import '../../../widgets/customAuthBottom.dart';
import '../logic/signup_cubit.dart';
import '../logic/signup_state.dart';


 class SignupView extends StatefulWidget {
   const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
   final nameController = TextEditingController();

   final emailController = TextEditingController();

   final passController = TextEditingController();

   final GlobalKey<FormState> formKey = GlobalKey<FormState>();

   @override
  void dispose() {
    nameController.dispose();
     emailController.dispose();
     passController.dispose();
    super.dispose();
  }

   @override
   Widget build(BuildContext context) {
     return GestureDetector(
       onTap: ()=>FocusScope.of(context).unfocus(),
       child: Scaffold(
         backgroundColor: AppColors.primary,
         body: SingleChildScrollView(
           child: Padding(
             padding: const EdgeInsets.symmetric(horizontal: 12),
             child: Column(
               children: [
                 const Gap(100),
                 CustomText(
                   color: Colors.white,
                   text: "Cheese Gang!",
                   fontFamily: GoogleFonts.luckiestGuy().fontFamily,
                   size: 40,
                   weight: FontWeight.bold,
                 ),

                 const CustomText(
                     color: Colors.white,
                     text: "welcome Back!",
                     size: 13
                     , weight: FontWeight.w500),

                 const Gap(20),

                 BlocConsumer<SignupCubit,SignupState>(
                   listener: (context,state){
                     if(state is SignSuccess){
                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=>Root()));
                     }else if(state is SignFailure){
                       ScaffoldMessenger.of(context).showSnackBar(customSnack(state.message));
                     }
                   },
                     builder:(context,state){
                     return GlassmorphicContainer(
                       width: double.infinity,
                       height: 500,
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
                         padding: const EdgeInsets.symmetric(horizontal: 12),
                         child: Form(
                           key: formKey,
                           child: Column(
                             children: [
                               const Gap(50),
                               //name Field
                               CustomTextField(
                                 validator: (v){
                                    if(v==null||v.isEmpty){
                                      return "Please enter your name";
                                    }
                                    if(v.length<3){
                                      return "Name must be at least 3 characters";
                                    }
                                    return null;
                                 },
                                   hint: "Name",
                                   isPassword: false,
                                   controller: nameController),
                               const Gap(10),

                               //email Field
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

                               //pass Field
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

                               state is SignLoading
                                   ? const CupertinoActivityIndicator(color: Colors.white)
                                   : CustomAuthButton(
                                 onTap: () {
                                   if(formKey.currentState!.validate()){
                                     context.read<SignupCubit>().signUp(
                                         nameController.text.trim(),
                                         emailController.text.trim(),
                                         passController.text.trim()
                                     );
                                   }
                                 },
                                 text: "SignUp",
                                 color: Colors.white.withAlpha(26),
                                 textColor: Colors.white,
                                 fontSize: 18,
                               ),
                               const Gap(10),
                               //sign button
                               CustomAuthButton(
                                 onTap: () {
                                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=>LoginView()));
                                 },
                                 text: "Login?",
                                 color: Colors.white.withAlpha(26),
                                 textColor: Colors.white,
                                 fontSize: 18,
                               ),

                               TextButton(
                                 onPressed: () {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=>Root()));
                                 },
                                 child: const CustomText(
                                   text: "Continue As a Guest?",
                                   size: 15,
                                   weight: FontWeight.bold,
                                   color: Colors.white,
                                 ),
                               )
                             ],
                           ),
                         ),
                       ),
                     );
                     },
                 )
               ],
             ),
           ),
         ),
       ),
     );
   }
}


