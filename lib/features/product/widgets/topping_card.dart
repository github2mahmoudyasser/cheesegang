
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../shared/widgets/costum_text.dart';




class ToppingCard extends StatelessWidget {
  const ToppingCard({super.key,
    required this.image,
    required this.title,
    required this.border,
    required this.textColor,
    required this.onAdd
    });
  final String image,title;
  final Border border;
  final Color textColor;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onAdd,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          height: 85,
          width: 85,
          decoration:  BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: border
          ),
          child:    Column(
            children: [
              Skeleton.replace(
                  width: 60,
                  height: 50,
                  child: Image.network(image,width: 60,height:50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error ,stackTrace)=>Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    )
                    , )
              ),
              CustomText(text:
              title,size: 12,
                color:textColor,
                weight: FontWeight.w600,),
            ],
          ),
        ),
      ),
    );
  }
}






