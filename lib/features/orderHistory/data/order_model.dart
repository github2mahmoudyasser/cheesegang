

import 'package:hive_ce/hive.dart';
part 'order_model.g.dart';
      //get orderHis
    @HiveType(typeId: 8)
      class OrderHisModel{
      @HiveField(0)
          final int code;

      @HiveField(1)
      final String message;

      @HiveField(2)
      final List<OrderData> order;


          OrderHisModel({
            required this.code,
            required this.message,
            required this.order,
      });

           factory OrderHisModel.fromJson(Map<String,dynamic>json){
             return OrderHisModel(
                 code: json["code"]??200,
                 message: json["message"]?.toString()??"",
                 order: (json["data"] as List)
                     .map((items)=>OrderData.fromJson(items))
                     .toList()
             );

           }
      }
      @HiveType(typeId: 9)
      class OrderData{
        @HiveField(0)
        final int id;

        @HiveField(1)
        final String status;

        @HiveField(2)
        final String totalPrice;

        @HiveField(3)
        final String createdAt;

        @HiveField(4)
        final String productImage;

        OrderData({
          required this.id,
          required this.status,
          required this.totalPrice,
          required this.createdAt,
          required this.productImage,
      });
        factory OrderData.fromJson(Map<String, dynamic> json) {
          return OrderData(
            id: json['id'] ?? 0,
            status: json['status'] ?? '',
            totalPrice: json['total_price'] ?? '0',
            createdAt: json['created_at'] ?? '',
            productImage: json['product_image'] ?? '',
          );
        }

      }