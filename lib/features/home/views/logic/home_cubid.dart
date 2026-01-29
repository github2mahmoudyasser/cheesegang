

import 'package:cheesegang/core/network/api_error.dart';
import 'package:cheesegang/core/network/api_exception.dart';
import 'package:cheesegang/core/utils/pref_helper.dart';
import 'package:cheesegang/features/home/data/models/product_model.dart';
import 'package:cheesegang/features/home/data/repo/product_repo.dart';
import 'package:cheesegang/features/home/views/logic/home_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class HomeCubit extends Cubit<HomeState> {
  final ProductRepo productRepo;

  HomeCubit(this.productRepo) : super(ProductInitial());


   List<ProductModel> _allProducts = [];

   Set<int> favId = {}; // fast search in list by productId O(1)

 // reset home data
  void clearHomeData() {
    favId.clear();
    emit(ProductInitial());
  }

  Future<void> getProducts() async {
    emit(ProductLoading());
    try {
      final token = await PrefHelper.getToken();

      if (token == null || token.isEmpty || token == "Guest") {
        favId = {};
      }else {
        final cachedFav = await PrefHelper.getCachedFav(); //get fav from cached
        if (cachedFav.isNotEmpty) {
          favId =
              cachedFav.map((fav) => fav.id).toSet(); // catch id from the list
        }
      }



      //get data from Api
      final productData = await productRepo.getProducts();

      if (productData.isNotEmpty) {
        _allProducts = productData; //save data in this var i will use it in search
        // get data from Api or cached
        emit(ProductSuccess(products: productData, isOffline: false));
      } else {
        emit(ProductFailure(message: "No products found"));
      }
    } catch (e) {
      String errorMessage = "bad connection, please try again.";

      if (e is DioException) {
        errorMessage = ApiExceptions.handleError(e).toString();
      }
      emit(ProductFailure(message: errorMessage));
    }
  }



  // search
  void search(String text){
    final filterProducts = _allProducts
   . where((p)=> p.name.toLowerCase().contains(text.toLowerCase()))
        .toList();  // pick product by letters
    emit(ProductSuccess(products: filterProducts, isOffline: false));
  }
  
  // filter category
   void filterCategory(String categoryName){
    if(categoryName =="All"){
      emit(ProductSuccess(products: _allProducts, isOffline: false));
      
    }else{
      final filterCategory = _allProducts
          .where((p)=>p.name.toLowerCase().contains(categoryName.toLowerCase()))
          .toList();
      emit(ProductSuccess(products: filterCategory, isOffline: false));
      
    }
   }



   // add Fav products
  Future<void> addFavProducts({
    required int productId
})async{
    try{
      final favModel = IsFav(
          productId: productId
      );
      await productRepo.addFavourites(favModel);
      bool isAdded = favId.contains(productId); // ask item is fav or no
      emit(AddFavSuccess(favouritesModel: favModel));
      emit(ProductSuccess(products: _allProducts, isOffline: false));
    }catch(e){
      String msg = "Failed to add this item to favourites";
      if(e is ApiError){
        msg = e.toString();
      }
      emit(AddFavFailure(message: msg));
      emit(ProductSuccess(products: _allProducts, isOffline: false)); // reset data when failed to add fav
    }


  }

   void toggleFav(int productId)async{
     final token = await PrefHelper.getToken();

     if (token == null || token.isEmpty || token == "Guest") {
       emit(ProductGuestError());
       emit(ProductSuccess(products: _allProducts, isOffline: false));
       return;
     }

    if(favId.contains(productId)){ // ask for id
        favId.remove(productId); // if yes remove heart
      }else{
        favId.add(productId); // else add heart
      }
      emit(ProductSuccess(products: _allProducts, isOffline: false)); // draw screen whith new data
  }

}



