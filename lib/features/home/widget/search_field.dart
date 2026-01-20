
   import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
   class SearchField extends StatelessWidget {
     const SearchField({super.key,
       required this.controller,
       this.onChanged});

  final TextEditingController  controller;
   final Function(String)? onChanged;

     @override
     Widget build(BuildContext context) {
       return TextField(
         controller: controller,
         onChanged:  onChanged,
         cursorHeight: 20,
         cursorColor: Colors.black,
         decoration: InputDecoration(
           prefixIcon: const Icon(CupertinoIcons.search),
           hintText: "Search",
           enabledBorder: OutlineInputBorder(
             borderRadius: BorderRadius.circular(15),
             borderSide: const BorderSide(color: Colors.white),
           ),
           focusedBorder: OutlineInputBorder(
               borderRadius: BorderRadius.circular(15),
               borderSide: BorderSide(color: AppColors.primary)),
         ),
       );
     }
   }
