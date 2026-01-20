    import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../core/constants/app_colors.dart';
import 'costum_text.dart';
import '../../features/auth/widgets/customAuthBottom.dart';

     class ErrorScreen extends StatefulWidget {
       const ErrorScreen({super.key,
         required this.text,
         required this.buttonText,
         this.onTap,
         required this.logButtonText,
         this.log,});
       final String text;
       final String buttonText;
       final Function()? onTap;

       final String logButtonText;
       final Function()? log;


  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
       @override
       Widget build(BuildContext context) {
         return Scaffold(
           backgroundColor: Colors.white,
           body: Padding(
             padding: const EdgeInsets.symmetric(horizontal: 10),
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 CircleAvatar(
                   backgroundColor: Colors.white,
                   radius: 50,
                   child: Icon(Icons.error_outline, size: 70, color: AppColors.primary),
                 ),
                 const Gap(10),
                  Center(child: CustomText(
                     text:widget.text , color: Colors.black, size: 18, weight: FontWeight.bold)),
                 const Gap(30),
                 CustomAuthButton(
                   onTap: widget.onTap,
                   text: widget.buttonText,
                   color: AppColors.primary,
                   textColor: Colors.black,
                   fontSize: 18,
                 ),
                 Gap(10),
                 CustomAuthButton(
                   onTap: widget.log,
                   text: widget.logButtonText,
                   color: AppColors.primary,
                   textColor: Colors.black,
                   fontSize: 18,
                 ),
               ],
             ),
           ),
         );
       }
}
