

import 'package:cheesegang/core/network/api_exception.dart';
import 'package:cheesegang/features/home/data/models/product_model.dart';
import 'package:cheesegang/features/home/data/repo/product_repo.dart';
import 'package:cheesegang/features/home/views/logic/home_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class HomeCubit extends Cubit<HomeState> {
  final ProductRepo productRepo;

  HomeCubit(this.productRepo) : super(ProductInitial());

   List<ProductModel> _allProducts = [];

 // reset home data
  void clearHomeData() {
    emit(ProductInitial());
  }

  Future<void> getProducts() async {
    emit(ProductLoading());
    try {
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

}



