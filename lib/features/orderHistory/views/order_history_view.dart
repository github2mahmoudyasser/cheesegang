



import 'package:cheesegang/features/cart/views/logic/cart_cubit.dart';
import 'package:cheesegang/features/orderHistory/data/order_model.dart';
import 'package:cheesegang/features/orderHistory/views/logic/order_cubit.dart';
import 'package:cheesegang/features/orderHistory/views/logic/order_state.dart';
import 'package:cheesegang/features/orderHistory/widgets/Orders_card.dart';
import 'package:cheesegang/shared/widgets/costum_snakebar.dart';
import 'package:cheesegang/shared/widgets/costum_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../auth/view/login_screen/ui_view/login_view.dart';
import '../../auth/widgets/customAuthBottom.dart';



class OrderHistoryView extends StatefulWidget {
  const OrderHistoryView({super.key,});

  @override
  State<OrderHistoryView> createState() => _OrderHisViewState();
}

class _OrderHisViewState extends State<OrderHistoryView> {
  bool isGuest = false;
  bool isLoading = false;
  OrderHisModel? orderHisModel;

  @override
  void initState() {
    super.initState();
    context.read<OrderCubit>().getOrderHis();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        if (isGuest) {
          return _buildGuestView(context);
        }
        //cartScreen
        return Scaffold(
          backgroundColor: Colors.white,
          body: _buildBody(context, state),
        );
      },
    );
  }
  Widget _buildBody(BuildContext context, OrderState state) {
    final bool waitingServer = state is OrderLoading || state is OrderInitial;
    List<OrderData> orderData = [];
    if (state is OrderSuccess) { // make sure get data if any thing happen
      orderData = state.orderHisModel?.order ??[] ; // get new data
    } else if (state is OrderLoading) {
     orderData = state.orderHisModel?.order ?? []; // show old data when loading
    }

    // guest mode
    if (state is OrderGuest) {
      return _buildGuestView(context);
    }

    // if cart is empty
    if (!waitingServer && orderData.isEmpty) {
      return _buildEmptyOrderHisView(context);
    }


    //success get cart
    final List<dynamic> items = (waitingServer && orderData.isEmpty)
        ? List.generate(4, (index) => null)
        : orderData;
    if (  waitingServer||items .isNotEmpty ) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Skeletonizer(
          enabled: waitingServer,
          child: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await context.read<OrderCubit>().getOrderHis();
                  },
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];

                      if (item == null) {
                        return const OrdersCard(
                            orderId: 0,
                            price: "0.0",
                            image: "",
                            time:" 00"
                        );
                      }

                      return OrdersCard(
                        onDelete: ()=> context.read<OrderCubit>().deleteOrderHis(item.id),
                          orderId:item. id,
                          price:item. totalPrice,
                          image: item.productImage,
                          time: item.createdAt
                      );
                    },
                  ),
                ),
              ),

            ],
          ),
        ),
      );
    }

    // cart error
    if (state is OrderError) return _buildErrorView(context, state.message!);
    return const SizedBox.shrink();
  }

  Widget _buildEmptyOrderHisView(BuildContext context) {
    return RefreshIndicator(
      onRefresh:()async{
        await context.read<OrderCubit>().getOrderHis();

      },
      child: CustomScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart, size: 70,color: AppColors.primary,),
                  const Gap(10),
                  CustomText(text: "Your orderHistory is empty!",
                    size: 18,
                    weight:  FontWeight.bold,
                  ),
                  const Gap(20),
                  TextButton.icon(onPressed: ()=>context.read<OrderCubit>().getOrderHis(),
                    icon: const Icon(Icons.refresh),
                    label: const Text("Try Refresh"),)
                ],

              ),
            ),

          )
        ],

      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 70, color: AppColors.primary),
            const Gap(10),
            CustomText(text: message, size: 18, weight: FontWeight.bold),
            const Gap(30),
            CustomAuthButton(
              onTap: () => context.read<OrderCubit>().getOrderHis(),
              text: "Try Refresh",
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: 70, color: AppColors.primary),
              const Gap(10),
              CustomText(text: "Please login to see your orders", size: 18, weight: FontWeight.bold),
              const Gap(30),
              CustomAuthButton(
                onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const LoginView())),
                text: "Login Now",
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
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






