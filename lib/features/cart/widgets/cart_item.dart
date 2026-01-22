
import 'package:cheesegang/features/cart/views/logic/cart_state.dart';
import 'package:flutter/cupertino.dart';
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
    required this.desc,
    this.onAdd,
    this.onMin,
    this.onRemove,
    required this.quantity,
    required this.isLoading,
  });

  final String image, text, desc;
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
    final state = CartState();
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
                      child: Image.network(widget.image,
                          width: 100,
                          height: 100,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.broken_image,
                                color: Colors.grey),
                          ))),
                  CustomText(
                    text: widget.text,
                    weight: FontWeight.bold,
                  ),
                  CustomText(text: widget.desc),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: widget.onMin,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: AppColors.primary,
                        child: Icon(CupertinoIcons.minus, color: Colors.white),
                      ),
                    ),
                    Gap(20),
                    CustomText(
                      text: widget.quantity.toString(),
                      weight: FontWeight.w400,
                      size: 18,
                    ),
                    Gap(20),
                    GestureDetector(
                      onTap: widget.onAdd,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: AppColors.primary,
                        child: Icon(CupertinoIcons.add, color: Colors.white),
                      ),
                    ),
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
                        child:  widget.isLoading?
                        CupertinoActivityIndicator()
                        :CustomText(
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

