

import 'package:cheesegang/core/network/api_error.dart';
import 'package:cheesegang/core/utils/pref_helper.dart';
import 'package:cheesegang/features/cart/data/cart_model.dart';
import 'package:cheesegang/features/cart/data/cart_repo.dart';
import 'package:cheesegang/features/cart/views/logic/cart_state.dart';
import 'package:cheesegang/features/product/repo/details_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class CartCubit extends Cubit<CartState> {
  final CartRepo cartRepo;
  GetCartModel? currentModel;
  final DetailsRepo detailsRepo;
  CartCubit(this.cartRepo,  this.detailsRepo,  ) :super(CartInitial());

  //get cart
  Future<void> getCart() async {
    currentModel = await PrefHelper.getCachedCart();
    if ( currentModel != null) {
      emit(CartSuccess(cartModel: currentModel!));
    } else if (currentModel == null) {
      emit(CartLoading());
    }

    try {
      final cartData = await cartRepo.getCartData();
      if (cartData != null) {
        currentModel = cartData;
        emit(CartSuccess(cartModel: cartData));
      }
    } catch (e) {
      if (currentModel == null) {
        emit(CartError(message: "Check your internet connection"));
      }
    }
  }


 //change quantity
 void changeQuantity(int productId, int newQty)async{
    final items = CartModel(
        productId: productId,
        qty: newQty);
    final request = CartRequestModel(items: [items]);
    await  detailsRepo.addToCart(request);
   }


// delete from cart

 Future<void> deleteItem(int itemId)async{
 try{
   await cartRepo.removeCartItem(itemId);
   await getCart();
 }catch(e){
   await getCart();
   String msg = "Failed to delete item";
    if(e is ApiError){
      msg = e.toString();
    }
   emit(CartError(message: msg));
 }

 }





   //check out
  /*Future<void> checkOutOrder(List<CartItemModel> itemModel)async{
    emit(SaveOrderLoading());
    try{
     final List<CartModel> items  = itemModel.map((orders){
       return CartModel(
           productId:orders.productId,
           qty: orders.qty,
         spicy: double.tryParse(orders.spicy),
         toppings: orders.toppings.map((t) => t.id).toList(),
         options: orders.sideOptions.map((o) => o.id).toList(),
       );
    }).toList();
            final request = CartRequestModel(items: items);
            await cartRepo.checkOut(request);
     emit(SaveOrderSuccess());

    }catch(e){
      String msg = "Failed to checkout order";
      if(e is ApiError){
        msg = e.message;
      }
      emit(SaveOrderFailure(message: msg));
    }

  }

   */


}












