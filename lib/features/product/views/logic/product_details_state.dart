
import 'package:equatable/equatable.dart';

import '../../data/details_model.dart';

abstract class ProductDetailsState extends Equatable {
     @override
      List<Object?> get props => [];
      }

      // Initial state
      class InitialState extends ProductDetailsState{}

       // Topping state
      class GetToppingLoading extends ProductDetailsState{}

      class GetToppingSuccess extends ProductDetailsState{
       final List<DetailsModel> toppings;
        GetToppingSuccess({required this.toppings});
       @override
       List<Object?> get props => [toppings];

      }
      class GetToppingFailure extends ProductDetailsState{
        final String? message;
        GetToppingFailure({this.message});
        @override
        List<Object?> get props => [message];
      }




      // option states
        class GetOptionsInitial  extends ProductDetailsState{}
        class GetOptionsLoading extends ProductDetailsState{}
       class GetOptionsSuccess extends ProductDetailsState{
         final List<DetailsModel> options;
         GetOptionsSuccess({required this.options});
         @override
         List<Object?> get props => [options];

       }

       class GetOptionFailure extends ProductDetailsState{
        final String? message;
        GetOptionFailure({this.message});
        @override
        List<Object?> get props => [message];
       }





        // Add to cart states
       class AddToCartLoading extends ProductDetailsState{}
      class AddToCartSuccess extends ProductDetailsState{}
      class AddToCartFailure extends ProductDetailsState{
     final String? message;
      AddToCartFailure({this.message});
     @override
     List<Object?> get props => [message];
      }