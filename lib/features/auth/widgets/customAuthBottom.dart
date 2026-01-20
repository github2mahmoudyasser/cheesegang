


import 'package:flutter/material.dart';
import '../../../shared/widgets/costum_text.dart';

  class CustomAuthButton extends StatelessWidget {
  const CustomAuthButton({super.key,
    this.onTap,
    required this.text,
    this.color,
    this.textColor,
    this.fontSize,
    this.height,
    this.radius,
    this.width});

  final Function()?   onTap;

  final String text;
  final Color? color;
  final Color? textColor;
  final double? fontSize;
  final double? height;
  final double? radius;
  final double? width;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
          height:height?? 50,
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(radius??15)
          ),
          child: Center(
            child: CustomText(text: text,
              size :fontSize ,
              weight: FontWeight.w700,
              color: textColor,

            ),
          )


      ),
    );
  }
}




