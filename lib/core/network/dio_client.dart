


//بدل ما تكتب إعدادات Dio في كل مكان في المشروع
// تعمل class واحد مسؤول عن إعداد Dio
// وبعدين تستخدمه في كل الريكوستات.




import 'package:cheesegang/core/utils/pref_helper.dart';
          import 'package:dio/dio.dart';

import '../navigation/app_navigator.dart';

           class DioClient {
            final  Dio _dio  = Dio(
                BaseOptions(
                    connectTimeout: const Duration(seconds: 60),
                    receiveTimeout: const Duration(seconds: 60),
                  baseUrl: "https://sonic-zdi0.onrender.com/api",
                  headers: {"Accept":"application/json"}
                )

              );

             DioClient(){
               // this code to show the the result from Api in console
               // _dio.interceptors.add(
                 // LogInterceptor(
                  //  responseBody: true,
                   // requestBody: true,
                 // )
               // );
               _dio.interceptors.add(
                 InterceptorsWrapper(
                   onRequest: (option,handler)async{
                      final token = await PrefHelper.getToken();
                      if(token!=null&& token.isNotEmpty&& token!="Guest"){
                         option.headers["Authorization"] = "Bearer $token";
                      }
                      return handler.next(option);
                   },
                   onError: (DioException error,handler){
                      if(error.response?.statusCode==401){
                        PrefHelper.removeToken();

                        // الانتقال لصفحة اللوجن فوراً
                          navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);

                     print("Session Expired: Redirecting to Login...");
               }
                      return handler.next(error);
               }
                 )
               );
             }
             Dio get dio => _dio;
           }


/* TODO: Implementation of Auto-Logout Navigation
    Follow these steps when you are ready to polish the UX:
    ------------------------------------------------------
    1. Create a global key in a separate file (e.g., core/utils/navigator_key.dart):
       final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    2. Register the key in your main.dart inside MaterialApp:
       MaterialApp(navigatorKey: navigatorKey, ...)

    3. Use the key here to redirect the user:
       navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
    */














