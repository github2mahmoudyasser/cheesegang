

/*
import 'package:cheesegang/features/cart/data/cart_model.dart';
import 'package:cheesegang/features/checkout/views/logic/checkout_cubit.dart';
import 'package:cheesegang/features/orderHistory/data/order_model.dart';
import 'package:cheesegang/features/orderHistory/data/order_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/costum_text.dart';

class SuccessDialog extends StatefulWidget {
  const SuccessDialog({super.key,});

  @override
  State<SuccessDialog> createState() => _SuccessDialogState();
}

class _SuccessDialogState extends State<SuccessDialog> {

  OrderRepo orderRepo  = OrderRepo();
  bool isOrderLoading = false;
 List<CartModel> cartItems=[];
 late final  checkData  = context.read<CheckoutCubit>();
  @override
  Widget build(BuildContext context) {
    return Container(
       width: 120,
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.primary,
      ),
      child: GestureDetector(
        onTap: () {
             final confirmOrder = OrderRequestModel(items: []);
             context.read<CheckoutCubit>().confirmOrder(confirmOrder);
                showDialog(context: context,
                    builder: (cheese) {
                      return Dialog(
                          backgroundColor: Colors.transparent,
                          child:
                          Center(
                            child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child:
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  // مهم جدًا عشان ما يمتدش على الشاشة كلها
                                  children: [
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundColor: AppColors.primary,
                                      child:
                                      Icon(CupertinoIcons.check_mark,
                                        color: Colors.white, size: 30,),
                                    ),
                                    const Gap(10),
                                    const CustomText(
                                      text: "Success!", weight: FontWeight.bold,
                                      size: 20,),
                                    const Gap(5),
                                    CustomText(
                                        text: "Your payment was successful.\n"
                                            "A receipt for this purchase has"
                                            "\n been sent to your ema",
                                        size: 10,
                                        color: Colors.grey.shade400),

                                    const Gap(30),

                                    //close bottom
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: 200,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 15),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              15),
                                          color: AppColors.primary,
                                        ),
                                        child: Center(
                                          child: const CustomText(text: "Close",
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )

                                  ],
                                )
                            ),
                          )
                      );
                    }
                );

              },
        child: isOrderLoading
            ?CupertinoActivityIndicator(color: Colors.white)
            : const CustomText(text: "Order Now", color: Colors.white),
      ),
    );

  }
}

 */


