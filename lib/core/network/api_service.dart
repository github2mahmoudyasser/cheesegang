
import 'package:cheesegang/core/network/api_exception.dart';
import 'package:cheesegang/core/network/dio_client.dart';
import 'package:dio/dio.dart';



        //وظيفته: عمل طلبات GET, POST, PUT, DELETE بطريقة منظمة.
// TODO: Refactor these CRUD methods using a Generic Request Wrapper (Higher-Order Function)
// to apply the DRY (Don't Repeat Yourself) principle and centralize the try-catch block.


//Encapsulation
            class ApiService{
                final DioClient _dioClient = DioClient();//_dioClient.dio → دي نسخة Dio مجهزة مسبقًا:
              //  فيها Base URL
               // فيها Headers
                //فيها interceptor يحط التوكن تلقائيًا
                //يعني كل طلب GET أو POST أو DELETE هياخد التوكن والـ headers بدون ما تعمله يدويًا

                 ///crud methods
              //get
               Future<dynamic>get(String endPoint, {dynamic params})async{
                  try{
                    final response = await _dioClient.dio.get(endPoint,queryParameters:params);
                    return response.data;

                  }on DioException catch(e){
                    throw ApiExceptions.handleError(e);
                  }
               }

            //post
            Future<dynamic>post(String endPoint, dynamic body)async{
                try{
                  final response = await _dioClient.dio.post(endPoint,data: body);
                  return response.data;

                }on DioException catch(e){
                  throw  ApiExceptions.handleError(e);
                }
            }

            //put
              Future<dynamic> put(String endPoint, dynamic body)async{
                  try{
                    final response = await _dioClient.dio.put(endPoint,data: body);
                    return response.data;

                  }on DioException catch(e){
                    throw  ApiExceptions.handleError(e);
                  }
              }

            //delete
             Future<dynamic> delete(String endPoint, dynamic body,{dynamic params})async {
               try {
                 final response = await _dioClient.dio.delete(endPoint,data: body,queryParameters: params);
                 return response.data;

               }on DioException catch(e){
                 throw  ApiExceptions.handleError(e);
               }


             }

            }










