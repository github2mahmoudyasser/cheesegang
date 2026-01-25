





import 'package:cheesegang/core/constants/app_colors.dart';
import 'package:cheesegang/features/cart/data/cart_model.dart';
import 'package:cheesegang/features/cart/views/logic/cart_cubit.dart';
import 'package:cheesegang/features/checkout/data/checkout_model.dart';
import 'package:cheesegang/features/checkout/views/logic/checkout_cubit.dart';
import 'package:cheesegang/features/checkout/views/logic/checkout_state.dart';
import 'package:cheesegang/features/checkout/widgets/pay_widget.dart';
import 'package:cheesegang/features/orderHistory/views/order_history_view.dart';
import 'package:cheesegang/shared/widgets/costum_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../shared/widgets/costum_snakebar.dart';
import '../../Root/logic/root_cubit.dart';
import '../../cart/views/logic/cart_state.dart';

 class CheckoutView extends StatefulWidget {
   const CheckoutView({super.key, required this.totalPrice,});
   final double totalPrice;


   @override
   State<CheckoutView> createState() => _CheckoutViewState();
 }

 class _CheckoutViewState extends State<CheckoutView> {
   @override
  void initState() {
    super.initState();
    context.read<CheckoutCubit>().getProfileData();
  }
   @override
   Widget build(BuildContext context) {
     return BlocConsumer<CheckoutCubit,CheckoutState>(
       listener: (context,state){
         if (state is CheckoutSuccess) {
           _showOrderDonePopup(context); // نفتح الديالوج هنا مش في الـ onTap
         }
         if (state is CheckoutFailure) {
           ScaffoldMessenger.of(context).showSnackBar(customSnack(state.toString()));
         }
       },
         builder: (context,state){
             // to use cubit
           var cubit = context.read<CheckoutCubit>();
           var user = cubit.userModel;

           const double taxes  = 3.50;
           const double fees = 40.33;
           double totalPrice = widget.totalPrice+taxes+fees;

         return Scaffold(
           backgroundColor: Colors.white,
           appBar:  AppBar(
             elevation: 0,
             backgroundColor: Colors.white,
             leading: GestureDetector(
                 onTap: (){
                   Navigator.pop(context);
                 },
                 child: Icon(CupertinoIcons.arrow_left)),
           ),
           body: state is GetProfileLoading
             ? const Center(child: CircularProgressIndicator())
           :Padding(
             padding: const EdgeInsets.symmetric(horizontal: 15),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 CustomText(text: "Order summary",size: 20,weight: FontWeight.w600,),
                 Gap(10),
                 PayWidget(
                   order: widget.totalPrice.toStringAsFixed(2),
                     taxes: taxes.toStringAsFixed(2),
                     fees: fees.toStringAsFixed(2),
                     total: totalPrice.toStringAsFixed(2)
                 ) ,
                 Gap(80),
                 CustomText(text: "Payment methods",size: 20,weight: FontWeight.w600,),
                 Gap(20),
                 ///cash
                 ListTile(
                   onTap: ()=>cubit.changePayment("cash"),
                   contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                   shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(8)
                   ),
                   tileColor:Color(0xFF000000),
                   leading: Image.asset("assets/icon/cash.png",
                     width: 50,),
                   title: CustomText(text: "Cash on Delivery",color: Colors.white,),
                   trailing: Radio<String>(
                       activeColor:Colors.white,
                       value: "cash",
                       groupValue:cubit.selectPayment,
                       onChanged:  (c) => cubit.changePayment(c!)
                 ),
           ),

                 Gap(10),

                 ///visa
               user?.visa==null?SizedBox.shrink()
                     : ListTile(
                   onTap: ()=> cubit.changePayment("visa"),
                   contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 3),
                   shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(8)
                   ),
                   tileColor:AppColors.primary,
                   leading: Image.asset("assets/icon/visa.png",
                     width: 50,),
                   title: CustomText(text: "Debit",color: Colors.white,),
                   subtitle:CustomText(text:user?.visa??"3566 **** **** 0505",color: Colors.grey.shade400,),
                   trailing: Radio<String>(
                       activeColor:Colors.white,
                       value: "visa",
                       groupValue:cubit. selectPayment,
                       onChanged: (c)=> cubit.changePayment(c!)
                       ),
                 ),
                 Gap(10),
                 Row(
                   children: [
                     Checkbox(
                         activeColor: AppColors.primary,
                         value:true,
                         onChanged: (v){}),
                     CustomText(text: "Save card details for future payments")
                   ],
                 ),
                 Gap(65),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         CustomText(text: "Total",size: 20,),
                         CustomText(text:"\$ ${totalPrice.toStringAsFixed(2)}",
                             size:25,
                             weight: FontWeight.bold),
                       ],
                     ),

                     _successDialog(context,state)


                   ],
                 ),



               ],
             ),
           ),
         );
         }
         );


   }

   // success dialog
// success dialog
   Widget _successDialog(BuildContext context, CheckoutState state) {
     bool isLoading = state is CheckoutLoading;


     return GestureDetector(
       onTap:isLoading ?null:(){
         final cartState = context.read<CartCubit>().state;
         if(cartState is CartSuccess) {
           final cartItems = cartState.cartModel.cartData.items;

           var sendOrder = CheckoutModel(
               orders: cartItems.map((items) =>
                   OrderItem(
                       productId: items.productId,
                       qty: items.qty,
                       spicy: 0.1,
                       toppings: items.toppings.map((e) => e.id).toList(),
                       options: items.sideOptions.map((e) => e.id).toList()
                   )).toList()
           );
           context.read<CheckoutCubit>().confirmOrder(sendOrder);
         }else{
           ScaffoldMessenger.of(context).showSnackBar(customSnack("Failed to confirm order!"));
         }
       },
       child: Container(
         width: 120,
         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
         decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(15),
           color:  AppColors.primary,
         ),
         child: Center(
           child: isLoading
               ? const CupertinoActivityIndicator(color: Colors.white)
               : const CustomText(text: "Order Now", color: Colors.white),
         ),
       ),
     );
   }
   void _showOrderDonePopup(BuildContext context) {
     showDialog(
       context: context,
       barrierDismissible: false,
       builder: (context) => Dialog(
         backgroundColor: Colors.transparent,
         child: Container(
           padding: const EdgeInsets.all(20),
           decoration: BoxDecoration(
             color: Colors.white,
             borderRadius: BorderRadius.circular(12),
           ),
           child: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
               CircleAvatar(
                 radius: 40,
                 backgroundColor: AppColors.primary,
                 child: const Icon(CupertinoIcons.check_mark, color: Colors.white, size: 30),
               ),
               const Gap(10),
               const CustomText(text: "Success!", weight: FontWeight.bold, size: 20),
               const Gap(5),
               const CustomText(text: "Your payment was successful.", size: 12),
               const Gap(30),
               GestureDetector(
                 onTap: () {
                   Navigator.pop(context);
                   Navigator.pop(context);
                   context.read<RootCubit>().changeScreen(3);
                 },
                 child: Container(
                   width: 200,
                   padding: const EdgeInsets.symmetric(vertical: 15),
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(15),
                     color: AppColors.primary,
                   ),
                   child: const Center(child: CustomText(text: "View History", color: Colors.white)),
                 ),
               )
             ],
           ),
         ),
       ),
     );
   }
 }




//old code
/*
class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key,
    required this.totalPrice});
  final String totalPrice;


  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  String selectPayment = "cash";
  AuthRepo authRepo = AuthRepo();
  UserModel? userModel;

  Future<void> getProfileData()async{
    try {
      final userData = await authRepo.getProfileData();
      setState(() {
        userModel = userData;
      });


    }catch(e){
      String errorMsg = "error in profile";
      if (e is ApiError){
        errorMsg = e.toString();
      }
      ScaffoldMessenger.of(context).showSnackBar(customSnack(errorMsg));
    }

  }



   @override
  void initState() {
    getProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
      ),
       body:
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(text: "Order summary",size: 20,weight: FontWeight.w600,),
           Gap(10),
             PayWidget(order:widget.totalPrice,
                 taxes: "3.50",
                 fees: "40.33",
                 total:(double.parse(widget.totalPrice)+3.50+40.33).toStringAsFixed(2)
             ) ,
            Gap(80),
            CustomText(text: "Payment methods",size: 20,weight: FontWeight.w600,),
            Gap(20),
            ///cash
            ListTile(
              onTap: (){
                setState(() {
                  selectPayment = "cash";
                });
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
              ),
              tileColor:Color(0xFF000000),
              leading: Image.asset("assets/icon/cash.png",
                width: 50,),
              title: CustomText(text: "Cash on Delivery",color: Colors.white,),
               trailing: Radio<String>(
                activeColor:Colors.white,
                  value: "cash",
                  groupValue: selectPayment,
                  onChanged: (c){
                  setState(() {
                    selectPayment = c!;
                  });

                  }),
            ),

            Gap(10),

           ///visa
           userModel?.visa==null?SizedBox.shrink()
           : ListTile(
              onTap: (){
                setState(() {
                  selectPayment = "visa";
                });
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 3),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
              ),
              tileColor:AppColors.primary,
              leading: Image.asset("assets/icon/visa.png",
                width: 50,),
              title: CustomText(text: "Debit",color: Colors.white,),
              subtitle:CustomText(text:userModel?.visa??"3566 **** **** 0505",color: Colors.grey.shade400,),
              trailing: Radio<String>(
                  activeColor:Colors.white,
                  value: "visa",
                  groupValue: selectPayment,
                  onChanged: (c){
                    setState(() {
                      selectPayment = c!;
                    });

                  }),
            ),
            Gap(10),
            Row(
              children: [
                Checkbox(
                  activeColor: AppColors.primary,
                    value:true,
                    onChanged: (v){}),
                CustomText(text: "Save card details for future payments")
              ],
            ),
            Gap(65),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text: "Total",size: 20,),
                    CustomText(text:"\$ ${(double.parse(widget.totalPrice)+3.50+40.33)
                        .toStringAsFixed(2)}",
                        size:25,
                        weight: FontWeight.bold),
                  ],
                ),
              SuccessDialog()


              ],
            ),



          ],
        ),
      ),
    );
  }
}

 */
