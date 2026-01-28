

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cheesegang/features/favourites/data/favModel.dart';
import 'package:cheesegang/features/favourites/view/logic/fav_cubit.dart';
import 'package:cheesegang/features/favourites/view/logic/fav_states.dart';
import 'package:cheesegang/features/home/views/logic/home_cubid.dart';
import 'package:cheesegang/shared/widgets/costum_snakebar.dart';
import 'package:cheesegang/shared/widgets/costum_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../auth/view/login_screen/ui_view/login_view.dart';
import '../../auth/widgets/customAuthBottom.dart';
import '../../product/views/ui_view/product_details_view.dart';



class FavouritesView extends StatefulWidget {
 const FavouritesView({super.key,});

 @override
 State<FavouritesView> createState() => _FavouritesViewState();
}
class _FavouritesViewState extends State<FavouritesView> {

 @override
 void initState() {
  super.initState();
  context.read<FavCubit>().getFavourites();
 }

 @override
 Widget build(BuildContext context) {
  return Scaffold(
   backgroundColor: Colors.white,
   appBar: AppBar(
    title: const CustomText(text: "My Favourites ❤", size: 20, weight: FontWeight.bold),
    centerTitle: true,
    backgroundColor: Colors.white,
    elevation: 0,
   ),
   body: BlocConsumer<FavCubit, FavStates>(
    listener: (context, state) {
     if (state is FavFailure) {
      ScaffoldMessenger.of(context).showSnackBar(customSnack(state.message));
     }
    },
    builder: (context, state) {
     if (state is FavGuest) {
      return _buildGuestView(context);

     }


       List<FavouritesModel>? favData;
       if (state is FavSuccess) favData = state.favourites;

       bool isWaiting = state is FavLoading || state is FavInitial;

       // 3. لو مفيش داتا خالص (فاضية)
       if (!isWaiting && (favData == null || favData.isEmpty)) {
        return _buildEmptyView(context);
       }

       // 4. عرض الـ Skeletonizer أو البيانات الحقيقية
       final items = (isWaiting && favData == null)
           ? List.generate(6, (index) => null) // Fake items for skeleton
           : favData ?? [];

       return _buildList(context, items, isWaiting);
      }
   ),
  );
 }

 Widget _buildList(BuildContext context, List<dynamic> items, bool isWaiting) {
  return Skeletonizer(
   enabled: isWaiting,
   child: RefreshIndicator(
    onRefresh: () => context.read<FavCubit>().getFavourites(),
    child: ListView.builder(
     physics: const AlwaysScrollableScrollPhysics(),
     padding: const EdgeInsets.only(left: 20, right: 10,bottom: 150),
     itemCount: items.length,
     itemBuilder: (context, index) {
      final item = items[index];

      return GestureDetector(
       onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductDetailsView(
         image: item.image,
         productId: item.id,
         productPrice: item.price,)));
       },
        child: Card(
         color: Colors.white,
         margin: const EdgeInsets.only(bottom: 15),
         child: ListTile(
          leading: item == null
              ? Container(width: 50, color: Colors.grey)
              : CachedNetworkImage(
           imageUrl: item.image, width: 50),
          title: Text(item?.name ?? "Product Name Loading"),
          subtitle: CustomText(text: "\$ ${item?.price ?? '00'} ",color: Colors.green,),
          trailing: GestureDetector(
           onTap: ()=> context.read<FavCubit>().deleteFav(item.id),
              child: const Icon(Icons.delete, color: Colors.red)),
         ),
        ),
      );
     },
    ),
   ),
  );

 }

 Widget _buildEmptyView(BuildContext context) {
  return Center(
   child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
     Icon(Icons.favorite_border, size: 70, color: AppColors.primary),
     const Gap(10),
     const CustomText(text: "Your Favorites is empty!", size: 18, weight: FontWeight.bold),
     TextButton(onPressed: () => context.read<FavCubit>().getFavourites(), child: const Text("Refresh")),
    ],
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

