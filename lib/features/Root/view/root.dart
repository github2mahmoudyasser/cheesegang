
  import 'package:cheesegang/core/constants/app_colors.dart';
import 'package:cheesegang/features/Root/logic/root_cubit.dart';
import 'package:cheesegang/features/auth/view/profile_screen/ui_view/profile_view.dart';
import 'package:cheesegang/features/cart/views/ui_view/cart_view.dart';
import 'package:cheesegang/features/home/views/ui_view/home_view.dart';
import 'package:cheesegang/features/orderHistory/views/order_history_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:glassmorphism/glassmorphism.dart';
import '../../favourites/view/favourites_view.dart';

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

    return BlocBuilder<RootCubit, int>(
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
            child: GlassmorphicContainer(
              width: double.infinity,
              height: 70,
              borderRadius: 50,
              linearGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.white.withOpacity(0.1),
                ],
              ),
              border: 1,
              blur: 15,
              borderGradient: LinearGradient(
                colors: [
                  Colors.grey.withOpacity(0.3),
                  Colors.grey.withOpacity(0.05)
                ],
              ),
              child: BottomNavigationBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: AppColors.primary,
                unselectedItemColor: Colors.black,
                selectedFontSize: 11,
                unselectedFontSize: 10,
                currentIndex: state,
                onTap: (index) {
                  // الآن الـ RootCubit متاح للـ Context ده بسهولة
                  context.read<RootCubit>().changeScreen(index);
                },
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
          ),
        );
      },
    );
  }
}

