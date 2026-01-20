

 import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/costum_text.dart';









class SpicySlider extends StatefulWidget {
  const SpicySlider({super.key,
    required this.value,
    required this.onChanged});
  final double value;
  final ValueChanged<double> onChanged;

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
          // we make sized box to set height and width to 3d model
      SizedBox(
        height: 200,
        width: double.infinity,
        child: ModelViewer(
          src: "assets/3d/cheeseburger.glb",    // هنا الملف من الـ assets
          autoRotate: true,
          cameraControls: true,
          disableZoom: true,
          ar: false,

        ),
      ),





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


