
import 'package:flutter/material.dart';
class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.size,
    this.color,
    this.weight,
     this.fontFamily,
    this.height,
  });

  final String text;
  final double? size;
  final Color? color;
  final FontWeight? weight;
  final String? fontFamily;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Text(
      maxLines:2,
      overflow: TextOverflow.ellipsis,
      text,
      style:TextStyle(     // ← هنا ضيفت خط Google
        fontSize: size,
        fontWeight: weight,
        color: color,
        fontFamily: fontFamily,
        height: height
      ),
    );
  }
}













