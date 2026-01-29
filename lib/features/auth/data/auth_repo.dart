


// TODO: Implement IProductRepository interface to achieve full Abstraction.
// This will allow for easier Unit Testing and better adherence to the
// Dependency Inversion Principle (SOLID).
// This allows us to swap the Data Source  switching from API to Firebase or Mock Data)
// // without changing a single line of code in the UI or Business Logic.

import 'package:cheesegang/core/network/api_error.dart';
import 'package:cheesegang/core/network/api_exception.dart';
import 'package:cheesegang/core/network/api_service.dart';
import 'package:cheesegang/core/utils/pref_helper.dart';
import 'package:cheesegang/features/auth/data/user_model.dart';
import 'package:dio/dio.dart';


 //async await Asynchronous Optimization

             class AuthRepo {
              final ApiService  apiService;
              AuthRepo(this.apiService); //Dependency Injection
              bool isGuest = false;
              UserModel? _currentUser;  //Encapsulation

                // Dry(Don't repeat your self)
              Future<UserModel?> _auth(String endPoint, Map<String, dynamic>body) async {
                try {
                  final request = await apiService.post(endPoint, body);
                  if (request is ApiError) {
                    throw request;
                  }
                  if (request is Map<String, dynamic>) {
                    final msg = request["message"];
                    final code = request["code"].toString();
                    final data = request["data"];

                    if (code != "200" && code != "201") {
                      throw ApiError(message: msg);
                    }
                    final userData = UserModel.fromJson(data);
                    if (userData.token != null) {
                      await PrefHelper.saveToken(userData.token!); // save token
                      await PrefHelper.cachedUserData(userData);

                    }
                    isGuest = false;
                    _currentUser = userData;
                    return userData;
                  } else {
                    throw ApiError(message: "un Expected Error From Server");
                  }
                } on DioException catch (e) {
                  throw ApiExceptions.handleError(e);
                } catch (e) {
                  throw ApiError(message: e.toString());
                }
              }

              //login
              Future<UserModel?> login(String email, String password) async {
                return _auth(
                    "/login", {"email": email, "password":password});
              }

              // signUp
              Future<UserModel?> signUp(String name, String email, String password) async {
                return _auth("/register",
                    {"name": name, "email": email, "password": password});
              }

               // getProfileData
                Future<UserModel?> getProfileData()async{
                 try{
                   // before get data check token first
                   final token =  PrefHelper.getToken();
                   if(token==null||token=="Guest"){
                     return null;
                   }
                   // send call
                   final profileRequest = await apiService.get("/profile");

                   // the response
                   final profileResponse = UserModel.fromJson(profileRequest["data"]);

                   isGuest = false;
                   _currentUser = profileResponse;
                   return profileResponse;
                 }on DioException catch(e){
                   throw ApiExceptions.handleError(e);
                 }catch(e){
                   throw ApiError(message: e.toString());
                 }


                }


                //update profile

              Future<UserModel?> updateProfile({
                required String name,
                required String email,
                required String address,
                String ? visa,
                String ? imagePath
              })async{
                try{  // i collect user data because i will send it as a body in the call
                  final formData =FormData.fromMap({
                    "name":name,
                    "email":email,
                    "address":address,
                    if(visa!=null&&visa.isNotEmpty)  "Visa":visa,
                    if(imagePath!=null&&imagePath.isNotEmpty)
                      "image":await MultipartFile.fromFile(imagePath,filename: "profile.jpg"),

                  });

                  final updateRequest=
                  await apiService.post("/update-profile", formData); //send the call

                  if(updateRequest is ApiError){
                    throw updateRequest;
                  }
                  if (updateRequest is Map<String,dynamic>){
                    final msg = updateRequest["message"];
                    final code = updateRequest["code"];
                    final data =updateRequest["data"];

                    if(code!=201&&code!=200){
                      throw ApiError(message: msg);
                    }
                    final updateResponse =  UserModel.fromJson(data);
                    _currentUser = updateResponse;
                    return updateResponse;

                  }
                }on DioException catch(e){
                  throw ApiExceptions.handleError(e);
                } catch(e){
                  throw ApiError(message: e.toString());

                }
                return null;
              }



              //auto Login
          Future<UserModel?> autoLogin()async{
                // check userToken
            final token =  await PrefHelper.getToken();
            if(token==null){
              _guestMode();
              return null;
            }else if(token=="Guest"){
              _guestMode();
              return null;
            }
             // condition for auto login
            try{
              isGuest = false;
              final userData = await getProfileData();
              _currentUser = userData;
              return userData;
            }catch(e){
             isGuest = false;// if lose internet
             return _currentUser ??
                 UserModel(name: "Offline User",email: "offline@user.com");  //  fall back data if app lose internet and stop app go to login screen when lose internet
            }

          }



           //log out
               Future<void> logOut()async{
                try{
                  // tell Api i will log out
                  await apiService.post("/logout", {});

                  // delete token
                  await PrefHelper.removeToken();
                  _guestMode();
                }catch(e){
                   // if any thing happened it will log out
                  await PrefHelper.removeToken();
                  _guestMode();
                }
               }


          // Dry(Don't repeat your self)
             void _guestMode(){
                isGuest = true;
                _currentUser = null;
             }
            }










