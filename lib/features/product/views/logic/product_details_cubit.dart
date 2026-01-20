

   import 'package:cheesegang/core/network/api_error.dart';
import 'package:cheesegang/features/cart/data/cart_model.dart';
import 'package:cheesegang/features/cart/data/cart_repo.dart';
import 'package:cheesegang/features/product/repo/details_repo.dart';
import 'package:cheesegang/features/product/views/logic/product_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/details_model.dart';

class ProductDetailsCubit  extends Cubit<ProductDetailsState>{
  final DetailsRepo detailsRepo;
  final CartRepo cartRepo;
  List<DetailsModel>? toppings;
  List<DetailsModel>? options;
  ProductDetailsCubit(this.detailsRepo,this.cartRepo):super(InitialState());

   // getToppings
 Future<void> getToppings()async{
   emit(GetToppingLoading());
   try{
      final toppingData = await detailsRepo.getToppings();
      toppings = toppingData;
      emit(GetToppingSuccess(toppings: toppingData));

   }catch (e){
     String msg = "Failed to load toppings";
      if(e is ApiError){
        msg = e.message;
      }
     emit(GetToppingFailure(message: msg));
   }

 }

  // getOptions
  Future<void> getOptions()async{
    emit(GetOptionsLoading());
    try{
      final sideOptionData = await detailsRepo.getSideOptions();
      options  =sideOptionData;
      emit(GetOptionsSuccess(options: sideOptionData));

    }catch(e){
    String msg = "Failed to load sideOptions";
    if(e is ApiError){
    msg = e.message;
    }
    emit(GetOptionFailure(message: msg));

    }
  }



   //add to cart
  Future<void> addToCart({
    required int productId,
    required int qty,
    required double spicy,
    required List<int> toppings,
    required List<int> options,
})async{
   emit(AddToCartLoading());
   try{
     final cartItem = CartModel(
         productId: productId,
         qty: qty,
       spicy: spicy,
       toppings: toppings,
       options: options,
     );
     final request = CartRequestModel(items: [cartItem]);
    await detailsRepo.addToCart(request);
    emit(AddToCartSuccess());
  }catch(e){
  String msg = "Failed to add to cart";
  if(e is ApiError){
  msg = e.message;
  }
  emit(AddToCartFailure(message: msg));
  }

  }

  }




