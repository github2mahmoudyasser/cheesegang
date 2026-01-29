


               import 'package:cheesegang/core/network/api_error.dart';
                 import 'package:dio/dio.dart';
//S - Single Responsibility
 //O - Open/Closed Principle
 //Abstraction i do this: ApiExceptions.handleError
 // trans Dio to object Api error

                  class ApiExceptions {
                    static ApiError handleError(DioException error){
                       // handle errors from server
                        if(error.response !=null){
                          final statusCode = error.response?.statusCode;
                          final data = error.response?.data;

                            // underStand message from Api
                             if(data is Map<String,dynamic> && data["message"] !=null){
                               return ApiError(message: data["message"],statusCode: statusCode);
                             }
                             
                             
                             //handle errors if Api not sent message
                            switch(statusCode){
                              case 302:return ApiError(message: "Please try logging in or use a different email.",statusCode: 302);
                              case 400:return ApiError(message: "Bad request,try again later",statusCode: 400);
                              case 401:return ApiError(message: "Unauthorized,please login again",statusCode: 401);
                              case 403:return ApiError(message: "Forbidden access",statusCode: 403);
                              case 404:return ApiError(message: "Resource not found",statusCode: 404);
                              case 409:return ApiError(message: "Conflict occurred",statusCode: 409);
                              case 500:return ApiError(message: "Internal server error, try again",statusCode: 500);
                              case 503:return ApiError(message: "Server is currently unavailable",statusCode: 503);
                              default: return ApiError(message: "Server error: $statusCode", statusCode: statusCode);
                             }
                        }
                        // handle error from Dio
                        switch(error.type){
                          case DioExceptionType.connectionTimeout:
                            return ApiError(message: "Connection Timeout With Server");
                          case DioExceptionType.sendTimeout:
                            return ApiError(message: "Send Timeout In Connectivity");
                          case DioExceptionType.receiveTimeout:
                            return ApiError(message: "Receive Timeout In Connectivity");
                          case  DioExceptionType.connectionError:
                            return ApiError(message: "No internet connection");
                          case DioExceptionType.badCertificate:
                            return ApiError(message: "Internal security error (Bad Certificate");
                          case DioExceptionType.cancel:
                            return ApiError(message: "Request to server was cancelled");

                              //unknown error happened
                          case DioExceptionType.unknown:
                            if(error.message!=null&& error.message!.contains("SocketException")){ // عشان ال dio يفهم
                              return ApiError(message: "No Internet connection");
                            }
                             return ApiError(message: "Unknown Error: ${error.error}");

                          default: return ApiError(message: "something went wrong, please try again");

                        }
                    }
                  }

