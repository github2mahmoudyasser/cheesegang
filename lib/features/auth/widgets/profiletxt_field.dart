
  import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
 class ProfileTextField extends StatelessWidget {
    const ProfileTextField({super.key,
      required this.label,
      required this.controller,
      required this.isNumber
    });
         final bool isNumber ;
         final String label;
         final TextEditingController controller;
   @override
   Widget build(BuildContext context) {
     return  TextField(
         controller: controller,
         keyboardType: isNumber ? TextInputType.number : TextInputType.text,
         cursorColor: AppColors.primary,
         style: TextStyle(color: AppColors.primary),
         decoration: InputDecoration(
           labelText: label,
           labelStyle: TextStyle(color: AppColors.primary),
           enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primary), borderRadius: BorderRadius.circular(20)),
           focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primary), borderRadius: BorderRadius.circular(20)),
         ),
       );
     }
   }

