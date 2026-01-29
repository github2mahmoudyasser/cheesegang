

import 'package:cheesegang/core/utils/pref_helper.dart';
import 'package:cheesegang/features/auth/data/auth_repo.dart';
import 'package:cheesegang/features/cart/data/cart_model.dart';
import 'package:cheesegang/features/cart/data/cart_repo.dart';
import 'package:cheesegang/features/cart/views/logic/cart_state.dart';
import 'package:cheesegang/features/product/repo/details_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';


class CartCubit extends Cubit<CartState> {
  final CartRepo cartRepo;
  GetCartModel? cartModel;
  final DetailsRepo detailsRepo;
  final  AuthRepo authRepo;

  CartCubit(this.cartRepo,  this.detailsRepo,  this.authRepo ) :super(CartInitial());


  //get cart
  Future<void> getCart() async {
    cartModel = await PrefHelper.getCachedCart();
    final token = await PrefHelper.getToken();
    if (token == null || token.isEmpty || token== "Guest") {
      emit( CartGuest());
      return;
    }
    emit(CartLoading(currentModel: cartModel));
    try {
      final cartData = await cartRepo.getCartData();
      if (cartData != null) {
        cartModel = cartData;
        emit(CartSuccess(cartModel: cartData));
      }
    } catch (e) {
      if (cartModel == null) {
        emit( CartError(message: "Check your internet connection"));
      } else {
        emit(CartSuccess(cartModel: cartModel!));
      }
    }
  }

// delete from cart

  Future<void> deleteItem(int itemId) async {
    emit(DeleteLoading(itemId: itemId));
    // delete data from memory before delete it from server
    if (cartModel != null) {
      cartModel!.cartData.items.removeWhere((item) => item.itemId == itemId);
      emit(CartSuccess(cartModel: cartModel!));      // fast refresh in ui and get fast data
    }
    try {
      await cartRepo.removeCartItem(itemId); // delete from server
      await getCart(); // get new data

    } catch (e) {
      await getCart(); // get  data if failed to delete and give me msg
      emit(CartError(message: "Failed to delete this item!"));
    }
  }



  void clearCartData()async {
    await Hive.box<GetCartModel>("cartBox").clear(); // clear hive when user is guest
    emit(CartInitial());
  }
  }



























