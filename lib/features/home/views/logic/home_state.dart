

   import 'package:cheesegang/features/home/data/models/product_model.dart';
   import 'package:equatable/equatable.dart';
abstract class HomeState extends Equatable { // use equatable to stop unnecessary Rebuild
  @override
  List<Object?> get props => [];
}
   class ProductInitial extends HomeState{}
   class ProductLoading extends HomeState{}

   class ProductSuccess extends HomeState{
   final List<ProductModel> products;
   final  bool isOffline; // use offline here to tell user that he use offline mode!
    ProductSuccess({required this.products, required this.isOffline});

     @override
  List<Object?> get props=> [products,isOffline];
   }

   class ProductFailure extends HomeState{
      final String message;
      ProductFailure({required this.message});
      @override
      List<Object?> get props => [message];
   }