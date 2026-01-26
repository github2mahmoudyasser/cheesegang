
 import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/costum_text.dart';
class OrdersCard extends StatelessWidget {
  const OrdersCard({super.key,
    required this.orderId,
    required this.price,
    required this.image, required this.time, this.onDelete});

   final String image;
  final int orderId;
  final String price;
  final String time;
  final Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        child:
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Skeleton.replace(
                      width: 100,
                      height: 100,
                      child: CachedNetworkImage(imageUrl: image,
                        width: 100,
                        height: 100,
                        errorWidget: (context, error, stackTrace) => Container(
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.broken_image,
                              color: Colors.grey),
                        ),)),

                  Expanded(
                    child: Column(
                      children: [
                        CustomText(text: "OrderNumber: $orderId" ,
                          weight: FontWeight.bold,),
                        CustomText(text: "time : $time"),
                        CustomText(text: "Price : \$ $price"),

                      ],
                    ),
                  ),

                ],
              ),

            ),
            Gap(15),
            Container(
              width: 250,
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColors.primary,
              ),
              child: GestureDetector(
                onTap: onDelete,
                child: Center(
                  child: CustomText(text: "Remove from History",
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          ],
        )

    );

  }
}
