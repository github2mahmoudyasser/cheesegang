

import 'package:cheesegang/core/network/api_exception.dart';
import 'package:cheesegang/features/home/data/models/product_model.dart';
import 'package:cheesegang/features/home/data/repo/product_repo.dart';
import 'package:cheesegang/features/home/views/logic/home_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class HomeCubit extends Cubit<HomeState> {
  final ProductRepo productRepo;

  HomeCubit(this.productRepo) : super(ProductInitial());

  Future<void> getProducts() async {
    emit(ProductLoading());
    try {
      //get data from Api
      final productData = await productRepo.getProducts();

      if (productData.isNotEmpty) {
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
}


