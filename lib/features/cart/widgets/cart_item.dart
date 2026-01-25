
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/costum_text.dart';

class CartItem extends StatefulWidget {
  const CartItem({
    super.key,
    required this.image,
    required this.text,
    required this.spicy,
    this.onAdd,
    this.onMin,
    this.onRemove,
    required this.quantity,
    required this.isLoading, required this.price,
  });

  final String image, text, spicy,price;
  final Function()? onAdd;
  final Function()? onMin;
  final Function()? onRemove;
  final int quantity;
  final bool isLoading;

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context ) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Skeleton.replace(
                      width: 100,
                      height: 100,
                      child: CachedNetworkImage(imageUrl: widget.image,
                          width: 100,
                          height: 100,
                        errorWidget    : (context, error, stackTrace) => Container(
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.broken_image,
                                color: Colors.grey),
                          ),)),
                  CustomText(
                    text: widget.text,
                    weight: FontWeight.bold,
                  ),
                  CustomText(
                    text: widget.spicy,
                    weight: FontWeight.bold,
                  ),
                  CustomText(
                    text: widget.price,
                    weight: FontWeight.bold,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                 CustomText(text: "Qty",size: 18,weight: FontWeight.bold,),
                    Gap(20),
                    CustomText(
                      text:":",
                      weight: FontWeight.w400,
                      size: 15,
                    ),
                    Gap(20),
                 CustomText(text: widget.quantity.toString(),
                   size: 18,
                   weight: FontWeight.bold,
                 )
                  ],
                ),
                Gap(20),
                GestureDetector(
                    onTap: widget.onRemove,
                    child: Container(
                      width: 120,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.primary,
                      ),
                      child: Center(
                        child: CustomText(
                          text: "Remove",
                          color: Colors.white,
                        ),
                      ),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}

