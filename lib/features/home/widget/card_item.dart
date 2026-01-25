

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cheesegang/core/constants/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../shared/widgets/costum_text.dart';
class CardItem extends StatelessWidget {
  const CardItem({super.key,
     required this.image,
     required this.text,
     required this.desc,
     required this.rate});
  final String image, text, desc, rate;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child:
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(15),
              child: Skeleton.replace(
                width: 140,
                  height: 115,
                  child: CachedNetworkImage(imageUrl: image,width: 140,height:115,
                    fit: BoxFit.cover,
                    errorWidget: (context,url,error)=>Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image,color: Colors.grey,),
                    ),
                     )
              ),

            )),
            Gap(10),
            CustomText(text: text,
              weight: FontWeight.bold,
              size: 13,
                color: Colors.black,

            ),
            CustomText(
                text:desc,
              weight: FontWeight.w500,
              size: 12,color: Colors.grey.shade500),
            Gap(5),
            Row(
              children: [
                CustomText(text:"⭐ $rate",
                  weight: FontWeight.w500,
                  size: 12,
                color: Colors.black,),
                Spacer(),
                Icon(CupertinoIcons.heart,color: AppColors.primary,size: 20,)
              ],
            )
          ],
        ),
      ),
    );
  }
}
