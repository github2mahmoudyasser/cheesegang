
import 'package:equatable/equatable.dart';

import '../../data/details_model.dart';

abstract class ProductDetailsState extends Equatable {
     @override
      List<Object?> get props => [];
      }

      // Initial state
      class InitialExtra extends ProductDetailsState{}

       // Topping state
      class GetExtraLoading extends ProductDetailsState{}

      class GetExtraSuccess extends ProductDetailsState{
       final List<DetailsModel> extra;
        GetExtraSuccess({required this.extra});
       @override
       List<Object?> get props => [extra];

      }
      class GetExtraFailure extends ProductDetailsState{
        final String? message;
        GetExtraFailure({this.message});
        @override
        List<Object?> get props => [message];
      }





      //change qty
        class ChangeQuantity extends ProductDetailsState{
          final int quantity;
          ChangeQuantity({required this.quantity});
          @override
          List<Object?> get props => [quantity];
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