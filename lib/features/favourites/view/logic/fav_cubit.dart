

    import 'package:cheesegang/core/network/api_error.dart';
import 'package:cheesegang/core/utils/pref_helper.dart';
import 'package:cheesegang/features/favourites/data/favRepo.dart';
import 'package:cheesegang/features/favourites/view/logic/fav_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavCubit extends Cubit<FavStates>{
  final FavRepo favRepo;
   FavCubit(this.favRepo):super(FavInitial());


  //get favourites

 Future<void> getFavourites()async{
   emit(FavLoading());
   try{
     final favData = await favRepo.getFavourites();
     if(favData.isNotEmpty){
       await PrefHelper.cachedFavourites(favData);
       emit(FavSuccess(favourites: favData));
     }


   }catch(e){
     final cachedData = await PrefHelper.getCachedFav();
     if(cachedData.isNotEmpty){
       emit(FavSuccess(favourites: cachedData));
     }else{
       String msg = "Failed to load Favourites";
       if(e is ApiError){
         msg = e.toString();
       }
       emit(FavFailure(message: msg));

     }
   }

 }
}