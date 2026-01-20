

          import 'dart:core';

import 'package:cheesegang/core/network/api_error.dart';
import 'package:cheesegang/core/network/api_exception.dart';
import 'package:cheesegang/core/network/api_service.dart';
import 'package:cheesegang/features/home/data/models/product_model.dart';
import 'package:dio/dio.dart';
import 'package:hive_ce/hive.dart';

import '../../../../core/utils/pref_helper.dart';

class ProductRepo {
  final ApiService apiService;

  ProductRepo(this.apiService);


  //getProducts
  Future<List<ProductModel>> getProducts() async {
    try {
      // 1. طلب البيانات من السيرفر
      final productRequest = await apiService.get("/products");

      List<ProductModel> products = (productRequest["data"] as List)
          .map((product) => ProductModel.fromJson(product))
          .toList();

      // 2. حفظ البيانات في الكاش باستخدام الـ PrefHelper (آمن ومضمون)
      await PrefHelper.cacheProducts(products);

      return products;
    } on DioException catch (e) {
      // 3. لو السيرفر نايم أو النت فصل، هات اللي في الكاش
      final cachedProducts = await PrefHelper.getCachedProducts();
      if (cachedProducts.isNotEmpty) {
        return cachedProducts;
      }
      // لو الكاش كمان فاضي (أول مرة تشغيل)، ارمي الأيرور الحقيقي بتاع السيرفر
      throw ApiExceptions.handleError(e);
    } catch (e) {
      // 4. لأي خطأ آخر، برضه جرب الكاش الأول
      final cachedProducts = await PrefHelper.getCachedProducts();
      if (cachedProducts.isNotEmpty) {
        return cachedProducts;
      }
      throw ApiError(message: "Server is waking up, please try again.");
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




        //category

          }

          */