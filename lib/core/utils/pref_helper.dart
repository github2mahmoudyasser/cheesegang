            //الكلاس دا هتجيب التوكن الاول
           //  تخزين التوكن بعد ما اليوزر يعمل لوجين
           // فيها برضو مسح التوكن لما تعوز تعمل لوج اوت


            import 'package:cheesegang/features/product/data/details_model.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
            import '../../features/home/data/models/product_model.dart'; // تأكد من المسار صح

            class PrefHelper {
              static const String _userBoxName = "userBox";
              static const String _productsBoxName = "productsBox";
              static const String _toppingsBox = "toppingsBox";
              static const String _tokenKey = "auth_token";

               // <T> this mean that function is generic that's mean this box contain String:(token) or products model
               // open the box
              static Future<Box<T>> _getBox<T>(String boxName) async {  // this function to ask hive this box is open or no
                if (!Hive.isBoxOpen(boxName)) {
                  return await Hive.openBox<T>(boxName);
                }
                return Hive.box<T>(boxName);
              }

                 // get token
              static Future<String?> getToken() async {
                final box = await _getBox(_userBoxName); //send box name
                return box.get(_tokenKey);
              }


               //save token
              static Future<void> saveToken(String token) async {
                final box = await _getBox(_userBoxName);
                await box.put(_tokenKey, token);
              }


               //delete token
              static Future<void> removeToken() async {
                final box = await _getBox(_userBoxName);
                await box.delete(_tokenKey);
              }

                  //product box
             //put data in cached
              static Future<void> cacheProducts(List<ProductModel> products) async {
                final box = await _getBox<ProductModel>(_productsBoxName);
                await box.clear(); // delete old data
                await box.addAll(products); // open new data
              }

               // get data from cached
              static Future<List<ProductModel>> getCachedProducts() async {
                final box = await _getBox<ProductModel>(_productsBoxName);
                return box.values.toList();
              }

              // put topping data in cached
              static Future <void> cashedToppings(List<DetailsModel> toppings)async{
                final box =await _getBox<DetailsModel>(_toppingsBox);
                await box.clear(); // delete old data
                await box.addAll(toppings); // open new data
              }

              //get data from cached
             static Future<List<DetailsModel>> getCachedToppings()async{
                final box = await _getBox<DetailsModel>(_toppingsBox);
                return box.values.toList();
             }


                // save image
              // use email here because all users have different images
              static Future<void> saveUserImage(String email, String path) async {
                final box = await _getBox(_userBoxName);
                await box.put("profile_image_$email", path); //Key: profile_image_hossam@gmail.com
              }



               //get image
              static Future<String?> getUserImage(String email) async {
                final box = await _getBox(_userBoxName);
                return box.get("profile_image_$email");
              }
            }


            /*class PrefHelper {
                static const String _boxName = "userBox";
                 static const String _tokenKey  ="auth_token";

                    static Box _getBox()=> Hive.box(_boxName);
                  //getToken
                 static String? getToken(){
                  return _getBox().get(_tokenKey);
                }

                // saveToken
             static  Future<void> saveToken(String token)async{
                   await _getBox().put(_tokenKey, token);
               }

               // removeToken
            static  Future<void> removeToken()async{
                  await _getBox().delete(_tokenKey);

              }

                // save user image
                static Future<void> saveUserImage(String email, String path) async {
                  await _getBox().put("profile_image_$email", path);
                }

                // get user image
                static String? getUserImage(String email) {
                  return _getBox().get("profile_image_$email");
                }

                // remove user image
                static Future<void> removeUserImage(String email) async {
                  await _getBox().delete("profile_image_$email");
                }

            }

             */

















