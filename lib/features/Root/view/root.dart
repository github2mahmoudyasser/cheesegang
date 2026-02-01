
  import 'package:cheesegang/core/constants/app_colors.dart';
import 'package:cheesegang/features/Root/logic/root_cubit.dart';
import 'package:cheesegang/features/auth/view/profile_screen/logic/profile_cubit.dart';
import 'package:cheesegang/features/auth/view/profile_screen/logic/profile_state.dart';
import 'package:cheesegang/features/auth/view/profile_screen/ui_view/profile_view.dart';
import 'package:cheesegang/features/cart/views/logic/cart_cubit.dart';
import 'package:cheesegang/features/cart/views/logic/cart_state.dart';
import 'package:cheesegang/features/cart/views/ui_view/cart_view.dart';
import 'package:cheesegang/features/favourites/view/logic/fav_cubit.dart';
import 'package:cheesegang/features/home/views/ui_view/home_view.dart';
import 'package:cheesegang/features/orderHistory/views/logic/order_cubit.dart';
import 'package:cheesegang/features/orderHistory/views/order_history_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:glassmorphism/glassmorphism.dart';
import '../../../shared/widgets/costum_snakebar.dart';
import '../../auth/view/login_screen/ui_view/login_view.dart';
import '../../favourites/view/favourites_view.dart';
import '../../favourites/view/logic/fav_states.dart';
import '../../home/views/logic/home_cubid.dart';
import '../../home/views/logic/home_state.dart';
import '../../orderHistory/views/logic/order_state.dart';
import '../../product/views/logic/product_details_state.dart';

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomeView(),
      const CartView(),
      const FavouritesView(),
      const OrderHistoryView(),
      const ProfileView(),
    ];

    return MultiBlocListener(
      listeners: [
        //  Home & Favourites Sync
        BlocListener<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is ProductSuccess && state.isOffline) {
              ScaffoldMessenger.of(context).showSnackBar(customSnack("You are in offline mode"));
            }
            if (state is ProductFailure) {
              ScaffoldMessenger.of(context).showSnackBar(customSnack(state.message));
            }
            if (state is AddFavSuccess) {
              context.read<FavCubit>().getFavourites();

              final isAdded = context.read<HomeCubit>().favId.contains(state.favouritesModel.productId);
              String message =
              isAdded ? "Added to favourite list"
                  : "Removed from favourite list";
              ScaffoldMessenger.of(context).showSnackBar(customSnack(message));
            }
            if (state is AddFavFailure) {
              ScaffoldMessenger.of(context).showSnackBar(customSnack("Failed, try again"));
            }
            if (state is HomeGuest) {
              ScaffoldMessenger.of(context).showSnackBar(customSnack("Please login first to add favorites!"));
            }

          },
        ),

        //  Cart Sync
        BlocListener<CartCubit, CartState>(
          listener: (context, state) {
            if (state is CartError) {
              ScaffoldMessenger.of(context).showSnackBar(customSnack("Failed to get cart, please try again"));
            }
            if (state is DeleteFailure) {
              ScaffoldMessenger.of(context).showSnackBar(customSnack("Please, try again"));
            }
            // تحديث: لو مسحت منتج بنجاح، يفضل تحدث الـ Home عشان لو فيه زرار "In Cart" يتغير
            if (state is DeleteSuccess) {
              context.read<HomeCubit>().getProducts();
            }
          },
        ),

        //  Favourites Sync (Back to Home)
        BlocListener<FavCubit, FavStates>(
          listener: (context, state) {

            if (state is FavFailure) {
              ScaffoldMessenger.of(context).showSnackBar(customSnack(state.message));
            }
          },
        ),

        //  Orders Sync
        BlocListener<OrderCubit, OrderState>(
          listener: (context, state) {

            if (state is OrderError) {
              ScaffoldMessenger.of(context).showSnackBar(customSnack("Failed to update history"));
            }
          },
        ),

        // Profile Sync
        BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileFailure) {
              ScaffoldMessenger.of(context).showSnackBar(customSnack(state.message ?? "Something went wrong"));
            }
            if (state is LogOutSuccess) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginView()));
            }
            // تحديث: لو اليوزر حدّث بياناته (الاسم مثلاً)، حدّث الهوم عشان لو فيه رسالة Welcome Name
            if (state is UpdateProfileSuccess) {
              context.read<HomeCubit>().getProducts();
            }
          },
        )
      ],
      child: BlocBuilder<RootCubit, int>(
        builder: (context, state) {
          return Scaffold(
            extendBody: true,
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: IndexedStack(
              index: state,
              children: screens,
            ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 25),
              child:    GlassmorphicContainer(width: double.infinity,
                      height: 77,
                      borderRadius: 50,
                      linearGradient: LinearGradient(
                          colors:[
                            Colors.black.withAlpha(38),
                            Colors.black.withAlpha(13),
                          ]),
                      border: 0,
                      blur: 15,
                      borderGradient:LinearGradient(colors: [
                        Colors.white.withAlpha(51),   // 0.2 تقريبا
                        Colors.white.withAlpha(13),   // 0.05 تقريبا

                      ]),
                      child:BottomNavigationBar(
                        elevation: 0,
                        backgroundColor:Colors.transparent ,
                        type:BottomNavigationBarType.fixed ,
                        selectedItemColor:AppColors.primary ,
                        unselectedItemColor:Colors.black ,
                        currentIndex:state ,
                        onTap:(index)=> context.read<RootCubit>().changeScreen(index),
                                            items: const [
                      BottomNavigationBarItem(
                          icon: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Icon(CupertinoIcons.home, size: 22),
                          ),
                          label: "Home"),
                      BottomNavigationBarItem(
                          icon: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Icon(CupertinoIcons.cart, size: 22),
                          ),
                          label: "Cart"),
                      BottomNavigationBarItem(
                          icon: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Icon(CupertinoIcons.heart_fill, size: 22),
                          ),
                          label: "Fav"),
                      BottomNavigationBarItem(
                          icon: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Icon(Icons.local_restaurant_sharp, size: 22),
                          ),
                          label: "Orders"),
                      BottomNavigationBarItem(
                          icon: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Icon(CupertinoIcons.person, size: 22),
                          ),
                          label: "Profile"),
                                            ],
                                          ),
                ),
              )
          );
        },
      ),
    );
  }
}

