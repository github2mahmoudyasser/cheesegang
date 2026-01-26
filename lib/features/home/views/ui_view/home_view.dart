import 'dart:io';
import 'package:cheesegang/core/constants/app_colors.dart';
import 'package:cheesegang/features/product/views/ui_view/product_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:cheesegang/features/home/data/models/product_model.dart';
import 'package:cheesegang/features/home/views/logic/home_cubid.dart';
import 'package:cheesegang/features/home/views/logic/home_state.dart';
import 'package:cheesegang/features/home/widget/card_item.dart';
import 'package:cheesegang/shared/widgets/costum_snakebar.dart';
import '../../../../shared/widgets/costum_text.dart';
import '../../widget/search_field.dart';
import '../../../auth/view/profile_screen/logic/profile_cubit.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController searchController = TextEditingController();


  final List<String> category = ["All", "Combo", "Sliders", "Classic"];
  int selectIndex = 0;

  @override
  void initState() {
    super.initState();
    // بنادي على البيانات مرة واحدة عند تشغيل الصفحة
    context.read<HomeCubit>().getProducts();
    context.read<ProfileCubit>().getProfileData();
  }
  @override
  void dispose() {
    searchController.dispose(); // make this to stop controller to stop build screen when i open text field
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // بنراقب حالة البروفايل عشان لو الصورة اتغيرت الـ UI يتحدث
    final profileCubit = context.watch<ProfileCubit>();
    final user = profileCubit.userModel;

    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // ================= Header Section =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(30),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: "Cheese Gang!",
                              color: AppColors.primary,
                              size: 35,
                              fontFamily: GoogleFonts.luckiestGuy().fontFamily,
                              height: 0.6,
                            ),
                            const Gap(3),
                            CustomText(
                              text: "Hello, ${user?.name ?? 'Sir'}", // هيعرض الاسم لو موجود، لو مش موجود هيعرض Sir
                              size: 15,
                              color: Colors.grey.shade400,
                              weight: FontWeight.w500,
                            ),
                          ],
                        ),
                        const Spacer(),
                        // ================= Profile Image Logic =================
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey.shade200,
                          child: ClipOval(
                            child: profileCubit.selectImage != null
                            // 1. صورة مختارة من الجهاز
                                ? Image.file(
                              File(profileCubit.selectImage!),
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            )
                             : (profileCubit.localImage != null)
                                ? Image.file(
                              File(profileCubit.localImage!),
                              width: 60, height: 60, fit: BoxFit.cover,
                            )
                            // 3. أيقونة افتراضية
                                : const Icon(Icons.person, size: 40, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    const Gap(10),
                    const CustomText(
                      text: "Order, your favourite food!",
                      size: 18,
                      weight: FontWeight.w700,
                    ),
                    const Gap(5),
                    Material(
                      color: Colors.white,
                      elevation: 2,
                      borderRadius: BorderRadius.circular(15),
                      child: SearchField(
                        onChanged: (v){
                          context.read<HomeCubit>().search(v);
                        },
                        controller: searchController,
                      ),
                    ),
                    const Gap(5),
                    // ================= Categories =================
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(category.length, (index) {
                            return GestureDetector(
                              onTap: () => setState(() => selectIndex = index),
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: selectIndex == index
                                      ? AppColors.primary
                                      : const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 27, vertical: 12),
                                  child: CustomText(
                                    text: category[index],
                                    weight: FontWeight.w500,
                                    color: selectIndex == index
                                        ? Colors.white
                                        : Colors.grey.shade500,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ================= Products Grid =================
              Expanded(
                child: BlocConsumer<HomeCubit, HomeState>(
                  listener: (context, state) {
                    if(state is ProductSuccess&& state.isOffline){
                      ScaffoldMessenger.of(context).showSnackBar(customSnack("You use offline mode,check your internet"));
                    }

                    if (state is ProductFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(customSnack(state.message));
                    }
                  },
                  builder: (context, state) {
                    bool isError = state is ProductFailure;
                    bool isLoading = state is ProductLoading; // we use it to know data is loading or now to open Skeleton
                    final List<ProductModel> products = (state is ProductSuccess) ? state.products : []; // this line to show data if success show products else show[];

                    return RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () async {
                        // تصفير الصورة المختارة عند السحب للتحديث لرجوع صورة السيرفر
                        context.read<ProfileCubit>().selectImage = null;
                        await Future.wait([
                          context.read<HomeCubit>().getProducts(),
                          context.read<ProfileCubit>().getProfileData(),
                        ]);
                      },
                      child: CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          // bad connection state
                         if(isError) // i use sliver fill Remaining to hide empty space in customScroll view and make the widget in  center
                           SliverFillRemaining(
                             hasScrollBody: false, // عشان تظهر في نص الشاشة بالظبط
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 const Icon(Icons.wifi_off_rounded, size: 100, color: Colors.grey),
                                 const SizedBox(height: 16),
                                 const Text(
                                   "Bad Connection",
                                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                 ),
                                 const SizedBox(height: 8),
                                 const Text("Please check your internet and try again"),
                                 const SizedBox(height: 24),
                                 ElevatedButton(
                                   onPressed: () => context.read<HomeCubit>().getProducts(),
                                   child: const Text("Retry Now"),
                                 ),
                               ],
                             ),

                           )
                         else
                           SliverPadding(
                             padding: const EdgeInsets.symmetric(horizontal: 15),
                             sliver: Skeletonizer.sliver(
                               enabled: isLoading,
                               child: SliverGrid(
                                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                   crossAxisCount: 2,
                                   mainAxisSpacing: 10,
                                   crossAxisSpacing: 10,
                                   childAspectRatio: 0.65,
                                 ),
                                 delegate: SliverChildBuilderDelegate(
                                       (context, index) {
                                     // i make here fake data when data load
                                     final product = isLoading
                                         ? ProductModel(
                                         name: "Loading...",
                                         price: "0",
                                         desc: "...",
                                         image: "image",
                                         id: 0,
                                         rate: "5")
                                         : products[index];

                                     return GestureDetector(
                                       onTap: (){
                                         Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductDetailsView(
                                           image: product.image,
                                           productId: product.id,
                                           productPrice: product.price,)));
                                       },
                                       child: CardItem(
                                         //  i use product here because when data is load this variable will show fake data it help me stop crash when load data
                                         image: product.image,
                                         text: product.name,
                                         desc: product.desc,
                                         rate: product.rate,
                                       ),
                                     );
                                   },
                                   childCount: isLoading ? 6 : products.length,
                                 ),
                               ),
                             ),
                           ),
                           const SliverToBoxAdapter(child: Gap(20)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
