

          import 'dart:core';

import 'package:cheesegang/core/network/api_error.dart';
import 'package:cheesegang/core/network/api_exception.dart';
import 'package:cheesegang/core/network/api_service.dart';
import 'package:cheesegang/features/home/data/models/product_model.dart';
import 'package:dio/dio.dart';
import '../../../../core/utils/pref_helper.dart';

class ProductRepo {
  final ApiService apiService;

  ProductRepo(this.apiService);

//S - Single Responsibility do one thing
  //O - Open/Closed can i add any thing
  //D - Dependency Inversion add api in repo help me for test


  //getProducts
  Future<List<ProductModel>> getProducts() async {
    try {
      final productRequest = await apiService.get("/products");

      List<ProductModel> products = (productRequest["data"] as List)
          .map((product) => ProductModel.fromJson(product))
          .toList();

      await PrefHelper.cacheProducts(products);

      return products;
    } on DioException catch (e) {
      final cachedProducts = await PrefHelper.getCachedProducts();
      if (cachedProducts.isNotEmpty) {
        return cachedProducts;
      }
      throw ApiExceptions.handleError(e);
    } catch (e) {
      final cachedProducts = await PrefHelper.getCachedProducts();
      if (cachedProducts.isNotEmpty) {
        return cachedProducts;
      }
      throw ApiError(message: "Server is waking up, please try again.");
    }
  }


   // add favourites
  Future<void> addFavourites(IsFav fav)async{
    try{
       final addFavRequest = await apiService.post("/toggle-favorite", fav.toJson());
        if(addFavRequest is ApiError){
          throw addFavRequest;
        }
    }on DioException catch(e){
      throw ApiExceptions.handleError(e);
    }catch(e){
      throw ApiError(message: e.toString());
    }
  }
}













       

/*
            //search
             Future<List<ProductModel>> search(String name)async{
              try{
                final searchRequest = await apiService.get("/products",params: {"name":name});
                return (searchRequest["data"] as List)
                    .map((product)=>ProductModel.fromJson(product)).toList();
              }catch(e){
                return [];
              }
             }

          */