
/*
  import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/costum_text.dart';
 class FinishOrder extends StatefulWidget {
   const FinishOrder({super.key, required this.productPrice, required this.text, required this.onTap});
      final String productPrice;
      final String text;
      final Function() onTap;
   @override
   State<FinishOrder> createState() => _FinishOrderState();
 }

 class _FinishOrderState extends State<FinishOrder> {
   bool isLoading= false;

   @override
   Widget build(BuildContext context) {
     return  Padding(
       padding: const EdgeInsets.symmetric(horizontal: 10),
       child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           //Total Price
           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               CustomText(text: "Total:",size: 20,color: Colors.black,),
               CustomText(text: "\$ ${widget.productPrice}",size:25,weight: FontWeight.bold,color: Colors.black),
             ],
           ),

           //AddToCart
           GestureDetector(
             onTap: (){},

             child: Container(
               padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(15),
                 color: AppColors.primary,
               ),
               child: isLoading
                   ? Row(
                 children: [
                   CustomText(
                     text: "Add To Cart",
                     color: Colors.white,
                   ),
                 const  Gap(10),
                   CupertinoActivityIndicator(color: Colors.white,),
                 ],
               )
                   : CustomText(
                 text:"Add To Cart",
                 color: Colors.white,
               ),
             ),
           )
         ],
       ),
     );
   }
 }

 */
