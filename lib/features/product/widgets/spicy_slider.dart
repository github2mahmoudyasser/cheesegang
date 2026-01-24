

 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/costum_text.dart';









class SpicySlider extends StatefulWidget {
  const SpicySlider({super.key,
    required this.value,
    required this.onChanged, this.onAdd, this.onMin, required this.quantity, });
  final double value;
  final ValueChanged<double> onChanged;
  final Function()? onAdd;
  final Function()? onMin;
  final int quantity;

  @override
  State<SpicySlider> createState() => _SpicySliderState();
}

class _SpicySliderState extends State<SpicySlider> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
               children: [
            const Gap(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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

          const Gap(10),
             SizedBox(
               width: 250,
               child: Slider(
                        min: 0,
                        max: 1,
                        value: widget.value,
                        onChanged: widget.onChanged
                        ,activeColor: AppColors.primary,

                      ),
             ),

              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(text: "Cold🥶",weight: FontWeight.bold,),
                 const Gap(150),
                  CustomText(text: "🌶Hot",weight: FontWeight.bold)
                ],
              )
            ],
      ),
    );
  }
}


