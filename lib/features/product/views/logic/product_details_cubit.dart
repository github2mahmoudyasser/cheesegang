

   import 'package:cheesegang/core/network/api_error.dart';
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
  int quantity = 1;
  ProductDetailsCubit(this.detailsRepo,this.cartRepo):super(InitialExtra());

   // getToppings
 Future<void> getToppings()async{
   emit(GetExtraLoading());
   try{
      final toppingData = await detailsRepo.getToppings();
      toppings = toppingData;
      emit(GetExtraSuccess(extra: toppingData));

   }catch (e){
     String msg = "Failed to load toppings";
      if(e is ApiError){
        msg = e.message;
      }
     emit(GetExtraFailure(message: msg));
   }

 }

  // getOptions
  Future<void> getOptions()async{
    emit(GetExtraLoading());
    try{
      final sideOptionData = await detailsRepo.getOptions();
      options  =sideOptionData;
      emit(GetExtraSuccess(extra:options!));

    }catch(e){
    String msg = "Failed to load sideOptions";
    if(e is ApiError){
    msg = e.message;
    }
    emit(GetExtraFailure(message: msg));

    }
  }


  void changeQuantity(int newQty){
   if(quantity + newQty >=1){
     quantity +=newQty;
     emit(ChangeQuantity(quantity: quantity));

   }
  }



   //add to cart
  Future<void> addToCart({
    required int productId,
    required double spicy,
    required List<int> toppings,
    required List<int> options,
})async{
   emit(AddToCartLoading());
   try{
     final cartItem = SandwichModel(
         productId: productId,
         qty: quantity,
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

  void resetState() {
   quantity = 1;
    emit(InitialExtra());
  }

  }




