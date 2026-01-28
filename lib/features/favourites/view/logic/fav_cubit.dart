

import 'package:cheesegang/core/utils/pref_helper.dart';
import 'package:cheesegang/features/favourites/data/favModel.dart';
import 'package:cheesegang/features/favourites/data/favRepo.dart';
import 'package:cheesegang/features/favourites/view/logic/fav_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';

class FavCubit extends Cubit<FavStates>{
  final FavRepo favRepo;
   FavCubit(this.favRepo):super(FavInitial());


  List<FavouritesModel> _allFav = [];

  Set<int> favId = {}; // fast search in list by productId O(1)

  //get favourites

  Future<void> getFavourites() async {
    emit(FavLoading());

    try {
      // 1. جلب البيانات من السيرفر
      final serverData = await favRepo.getFavourites();

      if (serverData != null) {
        var box = await Hive.openBox('delete_orders_his'); // open black list box


         //  if i add item from server and  delete it from black list
        for (var item in serverData) {
          if (box.containsKey(item.id)) {
            await box.delete(item.id);
          }
        }

        _allFav = serverData;
        await PrefHelper.cachedFavourites(serverData);
        emit(FavSuccess(favourites: List.from(_allFav)));
      }

    } catch (e) {
      final cachedData = await PrefHelper.getCachedFav(); //get data from cached

        // ask this item is deleted or no
      cachedData.removeWhere((item) => PrefHelper.isOrderDeleted(item.id));

      _allFav = cachedData;
      emit(FavSuccess(favourites: List.from(_allFav)));
    }
  }

  void deleteFav(int productId)async{
    await PrefHelper.addToBlackList(productId);
    _allFav.removeWhere((item)=>item.id==productId); // delete from local memory
    emit(FavSuccess(favourites: List.from(_allFav))); //  send new data
    try{
      await PrefHelper.cachedFavourites(_allFav); // update cached;
    }catch(e){
      emit(FavFailure(message: "failed, please try again"));

    }
  }

}





