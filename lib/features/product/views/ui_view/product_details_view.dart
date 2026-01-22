


import 'package:cheesegang/core/constants/app_colors.dart';
import 'package:cheesegang/features/cart/views/ui_view/cart_view.dart';
import 'package:cheesegang/features/product/views/logic/product_details_cubit.dart';
import 'package:cheesegang/features/product/views/logic/product_details_state.dart';
import 'package:cheesegang/features/product/widgets/spicy_slider.dart';
import 'package:cheesegang/features/product/widgets/topping_card.dart';
import 'package:cheesegang/shared/widgets/costum_snakebar.dart';
import 'package:cheesegang/shared/widgets/costum_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../data/details_model.dart';
  class ProductDetailsView extends StatefulWidget {
    const ProductDetailsView({super.key, required this.productId, required this.productPrice,});
    final int productId;
    final String productPrice;


    @override
    State<ProductDetailsView> createState() => _ProductDetailsViewState();
  }

  class _ProductDetailsViewState extends State<ProductDetailsView> {
    double value = 0.0;
    List<int> selectToppings=[];
    List<int> selectSideOptions=[];
    @override
    void initState() {
      super.initState();
      context.read<ProductDetailsCubit>().getToppings();
      context.read<ProductDetailsCubit>().getOptions();

    }

    @override
    Widget build(BuildContext context) {
      return BlocConsumer<ProductDetailsCubit,ProductDetailsState>(
        listener: (context,state){

          // topping failure
          if(state is GetToppingFailure){
            ScaffoldMessenger.of(context).showSnackBar(customSnack("Failed to load topping"));
          }

          //Option failure
          if(state is GetOptionFailure){
            ScaffoldMessenger.of(context).showSnackBar(customSnack("Failed to load SideOptions"));
          }

          //Add to cart state
          if(state is AddToCartSuccess){
           ScaffoldMessenger.of(context).showSnackBar(customSnack("Added to cart successfully"));
          }



        },

          builder: (context,state){
          bool loadToppings = state is GetToppingLoading;   // ask the state load or no
          final List<DetailsModel> toppings =
              context.read<ProductDetailsCubit>().toppings ?? []; // to fetch topping data
          bool loadSideOptions = state is GetOptionsLoading;
          final List<DetailsModel> options = context.read<ProductDetailsCubit>().options ?? [];

          return Scaffold(
             backgroundColor: Colors.white,
             // app bar
             appBar:  AppBar(
               elevation: 0,
               backgroundColor: Colors.white,
               leading: GestureDetector(
                   onTap: (){
                     Navigator.pop(context);
                   },
                   child: Icon(CupertinoIcons.arrow_left)),
             ),

             body: RefreshIndicator(
               backgroundColor: AppColors.primary,
               onRefresh: ()async{
                 await Future.wait([
                   context.read<ProductDetailsCubit>().getToppings(),
                   context.read<ProductDetailsCubit>().getOptions(),
                 ]
                 );

               },

               child: SingleChildScrollView(
                 physics: AlwaysScrollableScrollPhysics(),
                 child: Column(
                   children: [
                     // spicy slider contain 3d pic and slider
                     SpicySlider(value:value,
                         quantity: 1,
                         onAdd: (){},
                         onMin: (){},
                         onChanged:(v){
                       setState(() =>value = v);
                     }),
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         // topping name
                         Padding(
                           padding: const EdgeInsets.all(10),
                           child: CustomText(text: "Toppings",color: Colors.black,weight: FontWeight.w700,size: 15,),
                         ),

                         // toppings
                         Skeletonizer(
                           enabled: loadToppings ,
                           child: SingleChildScrollView(
                             scrollDirection: Axis.horizontal,
                             child: Row(
                               children: List.generate(
                                 // if state is load show 4 else show topping data
                                 loadToppings ? 4 : toppings.length,
                                     (index) {

                                   //set fake topping when load data
                                   final topping = loadToppings
                                       ? DetailsModel(
                                     id: 0,
                                     name: "Loading...",
                                     image: "image",
                                   )
                                       : toppings[index];
                                   final id  = topping.id;
                                   final isSelectToppings  = selectToppings.contains(id);

                                   return ToppingCard(
                                       image:topping.image,
                                       title: topping.name,
                                       border: Border.all(
                                         width: 2,
                                         color: isSelectToppings ? AppColors.primary:Colors.white,
                                       ),
                                       textColor: isSelectToppings ? Colors.black:Colors.grey.shade600,
                                       onAdd: (){
                                         if(loadToppings)return; // this line for stop  click when load data
                                         setState(() {
                                           if(isSelectToppings){
                                             selectToppings.remove(id);
                                           }else{
                                             selectToppings.add(id);
                                           }
                                         });
                                       });
                                 },
                               ),
                             ),
                           ),
                         ),

                         const Gap(10),

                         //side option name
                         Padding(
                           padding: const EdgeInsets.all(10),
                           child: CustomText(text: "Side Options",color: Colors.black,weight: FontWeight.w700,size: 15,),
                         ),
                         // side options
                         Skeletonizer(
                           enabled: loadSideOptions,
                           child: SingleChildScrollView(
                             scrollDirection: Axis.horizontal,
                             child: Row(
                               children: List.generate(
                                 loadSideOptions ? 4 : options.length,
                                     (index) {
                                   // بنجهز الـ Model للـ Options
                                   final option = loadSideOptions
                                       ? DetailsModel(
                                     id: 0,
                                     name: "Loading...",
                                     image: "image",
                                   )
                                       : options[index];
                                   final id = option.id;
                                   final isSelectOption = selectSideOptions.contains(id);

                                   return ToppingCard(
                                       image: option.image,
                                       title: option.name,
                                       border:Border.all(
                                           width: 2,
                                           color: isSelectOption ? AppColors.primary: Colors.white
                                       ),
                                       textColor: isSelectOption ? Colors.black:Colors.grey.shade600,
                                       onAdd: (){
                                         if(loadSideOptions)return;
                                         setState(() {
                                           if(isSelectOption){
                                             selectSideOptions.remove(id);
                                           }else{
                                             selectSideOptions.add(id);
                                           }
                                         });

                                       }
                                   );
                                 },
                               ),
                             ),
                           ),
                         ),

                         const Gap(25),

                         //finish order & TotalPrice
                         Padding(
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
                               state is AddToCartSuccess?
                               GestureDetector(
                                 onTap: (){
                                   context.read<ProductDetailsCubit>().resetState();
                                   Navigator.push(context, MaterialPageRoute(builder: (c)=>CartView()));
                                 },
                                 child: Container(
                                     padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                                     decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(15),
                                       color: AppColors.primary,
                                     ),
                                     child:CustomText(
                                       text:"View Cart",
                                       color: Colors.white,
                                     )
                                 ),
                               )

                              : GestureDetector(
                                 onTap: (){
                                   context.read<ProductDetailsCubit>().addToCart(
                                       productId: widget.productId,
                                       qty: 1,
                                       spicy: value,
                                       toppings: selectToppings,
                                       options: selectSideOptions);

                                 },


                                 child: Container(
                                   padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                                   decoration: BoxDecoration(
                                     borderRadius: BorderRadius.circular(15),
                                     color: AppColors.primary,
                                   ),
                                   child: state is AddToCartLoading
                                       ? Row(
                                     children: [
                                       CustomText(
                                         text:"Add To Cart",
                                         color: Colors.white,
                                       ),
                                       CupertinoActivityIndicator()
                                     ],
                                   )
                                       :CustomText(
                                     text:"Add To Cart",
                                     color: Colors.white,
                                   )


                                 ),
                               )

                             ],
                           ),
                         )

                       ],

                     ),


                   ],
                 ),
               ),
             ),

           );
         }
          );
    }
  }













/*
import 'package:cheesegang/core/constants/app_colors.dart';
import 'package:cheesegang/core/network/api_error.dart';
import 'package:cheesegang/core/network/api_service.dart';
import 'package:cheesegang/features/cart/data/cart_model.dart';
import 'package:cheesegang/features/cart/data/cart_repo.dart';
import 'package:cheesegang/features/product/widgets/topping_card.dart';
import 'package:cheesegang/features/product/widgets/spicy_slider.dart';
import 'package:cheesegang/shared/widgets/costum_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../home/data/repo/product_repo.dart';
class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({super.key,
    required this.productId,
    required this.productPrice
  });

    //variable use to send id to cartScreen
  final int productId;
  final String productPrice;

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  //variable for slider
   double value = 0.0;
       //variable to use AuthRepo
  ProductRepo productRepo = ProductRepo(ApiService());

  //variable to access topping & options items
  List<ToppingModel>? toppings;
  List<ToppingModel>? options;

    // variables use to show action when user click on items
  List<int> selectToppingIndex=[];
  List<int> selectSideOptions=[];

     bool isLoading = false;



  // getToppings

  Future<void> getToppings()async{
    final toppingData = await productRepo.getToppings();
    if (!mounted) return;
    setState(() {
      toppings = toppingData;
    });


  }

  //getSideOptions
  Future<void> getSideOptions()async{
    final sideOptionsData = await productRepo.sideOptions();
    if (!mounted) return;
    setState(() {
      options= sideOptionsData;
    });


  }

    //AddToCart
   CartRepo cartRepo = CartRepo();

  @override
  void initState() {
    getToppings();
    getSideOptions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
        Scaffold(
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
         SingleChildScrollView(
           child: Skeletonizer(
             enabled: toppings==null||options==null,
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [

                 //3d image and slider
               SpicySlider(
                 value: value,
                 onChanged: (v){
                   setState(() => value = v );
                 },
               ),
               Gap(20),
                 Padding(
                   padding: const EdgeInsets.all(10),

                   //toppingText
                   child: CustomText(text:
                   "Toppings",size:15,weight: FontWeight.w700,)
                 ),

                 //toppings
             SingleChildScrollView(
               scrollDirection: Axis.horizontal,
               child: Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 10),
                 child: Row(
                   children: List.generate(toppings?.length ??4, (index) {
                  final topping = toppings?[index];
                     final id = topping?.id;
                     if(topping==null){
                       return CupertinoActivityIndicator();
                     }
                      final isSelected = selectToppingIndex.contains(id);
                     return ToppingCard(
                       textColor:isSelected?Colors.black:Colors.grey.shade600 ,
                       border:Border.all(
                         width: 2,
                         color: isSelected?AppColors.primary:Colors.white,
                       ),
                       image: topping.image,
                       title: topping.name,
                         onAdd:  (){
                         setState(() {
                           if(isSelected){
                             selectToppingIndex.remove(id);
                           }else{
                             selectToppingIndex.add(id!);
                           }
                         });

                         }
                     );
                   }
                   ),
                 ),
               ),
             ),
                 Gap(10),
                 Padding(
                     padding: const EdgeInsets.all(10),
                     //sideOptionText
                     child: CustomText(text:
                     "Side Options",size: 15,weight: FontWeight.w700,)
                 ),

                    //sideOptions
                 SingleChildScrollView(
                   scrollDirection: Axis.horizontal,
                   child: Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 10),
                     child: Row(
                       children: List.generate(options?.length??4, (index){
                        final sideOption = options?[index];
                         final id = sideOption?.id;
                         if(sideOption==null){
                           return CupertinoActivityIndicator();
                         }
                         final isSelected = selectSideOptions.contains(id);

                         return ToppingCard(
                           textColor: isSelected?Colors.black:Colors.grey.shade600,
                           border: Border.all(
                             width: 2,
                             color: isSelected?AppColors.primary:Colors.white,
                           ),
                           image: sideOption.image,
                           title: sideOption.name,
                          onAdd:   (){
                            setState(() {
                              if(isSelected){
                                selectSideOptions.remove(id);
                              }else{
                               selectSideOptions.add(id!);
                              }
                            });

                          }
                           );
                       }
                       ),
                     ),
                   ),
                 ),
                 Gap(35),

                 Padding(
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
                         onTap: () async{
                           try {
                             setState(() => isLoading = true);
                             final cartItem = CartModel(
                                 productId: widget.productId,
                                 qty: 1,
                                 spicy: value,
                                 toppings: selectToppingIndex,
                                 options: selectSideOptions);

                              await cartRepo.addToCart(CartRequestModel(items:[cartItem]));
                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Added successfully to cart")));
                             setState(() => isLoading = false);

                           }catch(e){
                             setState(() => isLoading = false);
                             throw ApiError(message: e.toString());

                           }

                             },

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
                                 Gap(10),
                                 CupertinoActivityIndicator(color: Colors.white,),
                               ],
                             )
                                 : CustomText(
                               text: "Add To Cart",
                               color: Colors.white,
                             ),
                         ),
                       )
                     ],
                   ),
                 ),
             ],
             ),
           ),
         ),
    );
  }
}

 */

