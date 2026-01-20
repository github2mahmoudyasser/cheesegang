
























import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({super.key,
    required this.hint,
    required this.isPassword,
    required this.controller,
    this.validator});

  final String hint;
  final bool isPassword;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText; // to hide and show text


  @override
  void initState() {
    _obscureText = widget.isPassword;
    super.initState();
  }

  void _togglePassword(){
setState(() {
  _obscureText = !_obscureText; // fun to toggle on eye to show and hide text
});
  }


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      obscureText: _obscureText,
      cursorColor: AppColors.primary,
      cursorHeight: 20,
      controller:widget.controller ,
      decoration: InputDecoration(
        errorStyle: const TextStyle(
          color: Colors.white ),  // ← رسمة الفاليديتور باللون الأبيض
        suffixIcon:widget.isPassword?
        GestureDetector(
          onTap: _togglePassword,
            child: Icon(CupertinoIcons.eye)):null,
        hintText: widget.hint ,
        enabledBorder:OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.white)
        ) ,
        focusedBorder:OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.white)
        ) ,
        fillColor: Colors.white,
        filled: true,

      ),

    );
  }
}






