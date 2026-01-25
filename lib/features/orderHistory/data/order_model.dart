



      //get orders
      class GetOrderModel{
          final int code;
          final String message;
          final List<OrderData> order;


          GetOrderModel({
            required this.code,
            required this.message,
            required this.order,
      });

           factory GetOrderModel.fromJson(Map<String,dynamic>json){
             return GetOrderModel(
                 code: json["code"]??200,
                 message: json["message"]?.toString()??"",
                 order: (json["data"] as List)
                     .map((items)=>OrderData.fromJson(items))
                     .toList()
             );

           }
      }
      class OrderData{
        final int id;
        final String status;
        final String totalPrice;
        final String createdAt;
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