

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
    emit(CartLoading(currentModel: currentModel));
    try {
      final cartData = await cartRepo.getCartData();
      if (cartData != null) {
        currentModel = cartData;
        emit(CartSuccess(cartModel: cartData));
      }
    } catch (e) {
      if (currentModel == null) {
        emit(CartError(message: "Check your internet connection"));
      }else{
        emit(CartSuccess(cartModel: currentModel!));
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

  Future<void> deleteItem(int itemId) async {
    emit(DeleteLoading(itemId: itemId));
    // delete data from memory before delete it from server
    if (currentModel != null) {
      currentModel!.cartData.items.removeWhere((item) => item.itemId == itemId);
       emit(DeleteSuccess(cartModel:  currentModel!));       // fast refresh in ui and get fast data
    }
    try {
      await cartRepo.removeCartItem(itemId); // delete from server
      await getCart(); // get new data

    } catch (e) {
      await getCart(); // get  data if failed to delete and give me msg
      emit(CartError(message: "Failed to delete this item!"));
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












