
     import 'package:cheesegang/core/network/api_exception.dart';
import 'package:dio/dio.dart';

void main() async{
      final dio = Dio();
       const String baseUrl = "https://sonic-zdi0.onrender.com/api";

        try{
          final response = await dio.post("$baseUrl/login",
          data:{

            "email": "hossam3@gmail.com",
            "password":"123456789"
          }
          );
          print("success:${response.data}");
        }on DioException catch(e){
          final error = ApiExceptions.handleError(e);
          print("----------------------------------------");
          print("code: ${e.response?.statusCode}");
          print("----------------------------------------");
          print("data: ${e.response?.data}");
          print("----------------------------------------");
          print("message: ${error.message}");
           print("----------------------------------------");
        }

}