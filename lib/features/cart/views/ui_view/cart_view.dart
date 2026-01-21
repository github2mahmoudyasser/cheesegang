import 'package:cheesegang/features/cart/data/cart_model.dart';
import 'package:cheesegang/features/cart/views/logic/cart_cubit.dart';
import 'package:cheesegang/features/cart/views/logic/cart_state.dart';
import 'package:cheesegang/features/cart/widgets/cart_item.dart';
import 'package:cheesegang/features/product/views/logic/product_details_state.dart';
import 'package:cheesegang/shared/widgets/costum_snakebar.dart';
import 'package:cheesegang/shared/widgets/costum_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/widgets/customAuthBottom.dart';
import '../../../auth/view/login_screen/ui_view/login_view.dart';



class CartView extends StatefulWidget {
  const CartView({super.key,});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  bool isGuest = false;
  bool isLoading = false;
   GetCartModel? cartModel;

  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().getCart();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit, CartState>(
      listener: (context, state) {

        if(state is AddToCartSuccess){
          context.read<CartCubit>().getCart();
        }
        // checkout state
        if(state is SaveOrderSuccess){
          ScaffoldMessenger.of(context).showSnackBar(customSnack("Check Out Success"));
        }

       //cart error
        if (state is CartError) {
          ScaffoldMessenger.of(context).showSnackBar(
              customSnack("Failed to get cart, please try again"));
        }


        if(state is SaveOrderFailure){
          ScaffoldMessenger.of(context).showSnackBar(customSnack(state.message));
        }
      },
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
  Widget _buildBody(BuildContext context, CartState state) {
    final bool waitingServer = state is CartLoading || state is CartInitial;
    CartData? cartData;

    if (state is CartSuccess) {
      cartData = state.cartModel.cartData;  // get new data
    } else if (state is CartLoading) {
      cartData = state.currentModel?.cartData; // show old data when loading
    }

    // if cart is empty
    if (!waitingServer && cartData != null && cartData.items.isEmpty) {
      return _buildEmptyCartView(context);
    }

    if (cartData != null || waitingServer) {
      final items = (waitingServer && cartData == null)//  عملت كدا عشان المتغير دا يبقا المتحكم في الداتا لو في داتا يعرضها لو مفيش يعرض داتا وهمية
          ? List.generate(4, (index) => null) // if data = null show 4 fake item
          : cartData?.items ?? []; // or show cart items from Api or cached

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: ()async{
                  await context.read<CartCubit>().getCart();

                },
                child: Skeletonizer(
                  enabled: waitingServer ,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];

                      if (item == null) {
                        return const CartItem(isLoading: true,
                            image: '',
                            text: '...',
                            desc: '...',
                            quantity: 1);
                      }

                      return CartItem(
                        isLoading: false,
                        image: item.image,
                        text: item.name,
                        desc: "spicy ${item.spicy}",
                        quantity: item.qty,
                        onRemove: () => context.read<CartCubit>().deleteItem(item.itemId),
                      );
                    },
                  ),
                ),
              ),
            ),
            const Gap(10),
            if (cartData != null)
              _buildTotalSection(context, state, cartData),
            const Gap(85),
          ],
        ),
      );
    }

    if (state is CartError) return _buildErrorView(context, state.message!);
    return const SizedBox.shrink();
  }

  Widget _buildTotalSection(BuildContext context,CartState state,CartData product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(text: "Total", size: 20),
            CustomText(
              text: "\$ ${product.totalPrice}",
              size: 30,
              weight: FontWeight.bold,
            ),
          ],
        ),
        GestureDetector(
          onTap: (){},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: AppColors.primary,
            ),
            child: state is SaveOrderLoading
                ?Row(
              children: [
                CustomText(text: "Check Out", color: Colors.white),
                CupertinoActivityIndicator()
              ],
            )
                :CustomText(text: "Check Out", color: Colors.white),
          ),
        ),
      ],
    );
  }



  Widget _buildEmptyCartView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 70, color: AppColors.primary),
          const Gap(10),
          CustomText(text: "Your cart is empty!", size: 18, weight: FontWeight.bold),
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
              onTap: () => context.read<CartCubit>().getCart(),
              text: "Try Refresh",
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestView(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline, size: 70, color: AppColors.primary),
            const Gap(10),
            CustomText(text: "Please login to see your cart", size: 18, weight: FontWeight.bold),
            const Gap(30),
            CustomAuthButton(
              onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const LoginView())),
              text: "Login Now",
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  }






