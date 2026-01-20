

    import 'package:cheesegang/features/cart/data/cart_model.dart';
import 'package:equatable/equatable.dart';

class CartState extends Equatable{
  @override
  List<Object?> get props => [];

}

      class CartInitial extends CartState{}
     class CartLoading extends CartState{
     final GetCartModel? currentModel;
     CartLoading({ this.currentModel});
     }
    class CartSuccess extends CartState{
     final GetCartModel cartModel;
     CartSuccess({required this.cartModel});
    }

    class CartError extends CartState{
     final String? message;
       CartError({this.message});
    }

    class SaveOrderInitial extends CartState{}
    class SaveOrderLoading extends CartState{}
    class SaveOrderSuccess extends CartState{}
    class SaveOrderFailure extends CartState{
     final String message;
     SaveOrderFailure({required this.message});
    }