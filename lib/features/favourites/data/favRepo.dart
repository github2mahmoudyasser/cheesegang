

import 'package:cheesegang/core/network/api_error.dart';
import 'package:cheesegang/core/network/api_exception.dart';
import 'package:cheesegang/core/network/api_service.dart';
import 'package:cheesegang/core/utils/pref_helper.dart';
import 'package:dio/dio.dart';

import 'favModel.dart';

class FavRepo {
  final ApiService apiService;
  FavRepo(this.apiService);
  
  // get favourites
  Future<List<FavouritesModel>> getFavourites()async{
   try{
     final favRequest = await apiService.get("/favorites");
     List<FavouritesModel> favourites =(favRequest["data"]as List)
     .map((fav)=>FavouritesModel.fromJson(fav))
         .toList();

     await PrefHelper.cachedFavourites(favourites);
     return favourites;

   }on DioException catch(e){
      throw ApiExceptions.handleError(e);
   }catch(e){
     throw ApiError(message: e.toString());
   }
  }
}



   

    
   