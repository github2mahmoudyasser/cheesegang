

import 'package:equatable/equatable.dart';
import '../../data/order_model.dart';

class OrderState extends Equatable{
  @override
  List<Object?> get props => [];

}

class OrderInitial extends OrderState{}
class OrderLoading extends OrderState{
  final OrderHisModel? orderHisModel;
  OrderLoading({ this.orderHisModel});
  @override
  List<Object?> get props => [orderHisModel];
}
class OrderSuccess extends OrderState {
  final OrderHisModel? orderHisModel;
  OrderSuccess({required this.orderHisModel});
  @override
  List<Object?> get props => [orderHisModel];
}

class OrderError extends OrderState{
  final String? message;
  OrderError({this.message});
  @override
  List<Object?> get props => [message];
}

//gust mode
class OrderGuest extends OrderState{}

 class DeleteOrderLoad extends OrderState{
  final int? itemId;
  DeleteOrderLoad({this.itemId});
  @override
  List<Object?> get props => [itemId];
 }



