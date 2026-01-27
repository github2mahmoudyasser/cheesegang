

     import 'package:cheesegang/features/favourites/data/favModel.dart';
import 'package:equatable/equatable.dart';

abstract class FavStates extends Equatable {
       @override
       List<Object?> get props => [];
     }

     class FavInitial extends FavStates{}
     class FavLoading extends FavStates{}

     class FavSuccess extends FavStates{
       final List<FavouritesModel> favourites;
       FavSuccess({required this.favourites, });

       @override
       List<Object?> get props=> [favourites];
     }

     class FavFailure extends FavStates{
       final String message;
       FavFailure({required this.message});
       @override
       List<Object?> get props => [message];
     }