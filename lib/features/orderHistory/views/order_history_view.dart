



import 'package:cheesegang/features/orderHistory/data/order_model.dart';
import 'package:cheesegang/features/orderHistory/data/order_repo.dart';
import 'package:cheesegang/shared/widgets/costum_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../core/constants/app_colors.dart';
import '../../auth/widgets/customAuthBottom.dart';
import '../../auth/data/auth_repo.dart';
import '../../auth/data/user_model.dart';
import '../../auth/view/login_screen/logic/login_cubit.dart';
import '../../auth/view/login_screen/ui_view/login_view.dart';

class OrderHistoryView extends StatefulWidget {
  const OrderHistoryView({super.key});

  @override
  State<OrderHistoryView> createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: CustomText(text: "Order History")),

    );
  }
}



/*
class OrderHistoryView extends StatefulWidget {
  const OrderHistoryView({super.key});

  @override
  State<OrderHistoryView> createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView> {
  OrderRepo orderRepo= OrderRepo();
  AuthRepo authRepo = AuthRepo();
  bool isLoading = false;
  GetOrderModel? getOrderModel;
  bool isGuest = false;
  UserModel? userModel;
  bool load = false;

    // get order
  Future<void> getOrderData()async{
    try{
      if(!mounted) return;
      setState(() => isLoading = true);
      final orderDataRequest= await orderRepo.getOrderData();
      if(!mounted)return;
      setState(() {
       getOrderModel = orderDataRequest;
        isLoading =false;

      });
    }catch(e){
      setState(() =>isLoading = false);
      print(e.toString());
    }
  }
  //auto login
  Future<void> autoLogin() async {
    try {
      final user = await authRepo.autoLogin();

      if (!mounted) return;

      setState(() {
        isGuest = authRepo.isGuest;
        if (user != null) {
          userModel = user;
        }
      });
    } catch (e) {
      print("AUTO LOGIN ERROR: $e");
    }
  }

@override
    void initState() {
    autoLogin();
    getOrderData();
     super.initState();
  }



  @override
  Widget build(BuildContext context) {
    if(!isGuest){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(toolbarHeight: 0,
        scrolledUnderElevation: 0,backgroundColor: Colors.white,),
      body:
      Padding(
        padding: const EdgeInsets.symmetric(horizontal:15),
        child:
            RefreshIndicator(
              onRefresh: ()async{
                await getOrderData();
              },
              child: isLoading
                  ? const Center(child: CupertinoActivityIndicator())
                  : getOrderModel == null || getOrderModel!.order.isEmpty
                  ?Scaffold(
                    backgroundColor: Colors.white,
                    body: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment:MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 50,
                            child: Icon(Icons.error_outline,size: 70,color: AppColors.primary,),
                          ),
                          Gap(10),
                          Center(child: CustomText(text: "Some Thing Went Wrong!",color:Colors.black,size: 18,weight: FontWeight.bold,)),
                          Gap(30),
                              load? CupertinoActivityIndicator()
                                  :CustomAuthButton(
                                onTap: () async {
                                  setState(() => load = true);
                                  await getOrderData();
                                  if (!mounted) return;
                                  setState(() => load = false);
                                },
                                text: "Please Refresh!",
                                color: AppColors.primary,
                                textColor: Colors.black,
                                fontSize: 18,
                          ),
                          Gap(10),

                        ],
                      ),
                    ),
                  )
             : ListView.builder(
                padding: EdgeInsets.only(bottom: 50,top: 20),
                itemCount:getOrderModel?.order.length ?? 0,
                itemBuilder: (context, index) {
                  final order = getOrderModel!.order[index];
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
                                Image.network(order.productImage,width: 100,),

                                Column(
                                  children: [
                                    CustomText(text: "Hamburger",
                                      weight: FontWeight.bold,),
                                    CustomText(text: "time : ${order.createdAt}"),
                                    CustomText(text: "Price : \$${order.totalPrice}"),

                                  ],
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
                              onTap: () {},
                              child: Center(
                                child: CustomText(text: "Order Again",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Gap(15),
                        ],
                      )

                  );
                },
              ),
            ),


        ),
      );
  } else if(isGuest){
  return Center(
    child: Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment:MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 50,
              child: Icon(Icons.error_outline,size: 70,color: AppColors.primary,),
            ),
            Gap(10),
            Center(child: CustomText(text: "Go to Login? ",color:Colors.black,size: 18,weight: FontWeight.bold,)),
            Gap(30),
            CustomAuthButton(
              onTap:(){Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => LoginView()));
              },
              text: "Login",
              color: AppColors.primary,
              textColor: Colors.black,
              fontSize: 18,
            ),
            Gap(10),

          ],
        ),
      ),
    ),
  );
  }
  return  SizedBox.shrink();

  }
}

 */






