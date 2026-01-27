            //الكلاس دا هتجيب التوكن الاول
           //  تخزين التوكن بعد ما اليوزر يعمل لوجين
           // فيها برضو مسح التوكن لما تعوز تعمل لوج اوت


            import 'package:cheesegang/features/auth/data/user_model.dart';
import 'package:cheesegang/features/cart/data/cart_model.dart';
import 'package:cheesegang/features/favourites/data/favModel.dart';
import 'package:cheesegang/features/orderHistory/data/order_model.dart';
import 'package:cheesegang/features/product/data/details_model.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
            import '../../features/home/data/models/product_model.dart'; // تأكد من المسار صح

            class PrefHelper {
              static const String _userBoxName = "userBox";
              static const String _productsBoxName = "productsBox";
              static const String _toppingsBox = "toppingsBox";
              static const String _cartBox = "cartBox";
              static const String _orderHisBox = "orderHisBox";
              static const String _userDataBox ="userData";
              static const String _tokenKey = "auth_token";
              static const String _blackListBox = "delete_orders_his";
              static const String _favBox ="favBox";

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

             // cart box
              // put data in cached
              static Future<void> cachedCart(GetCartModel cart)async{
                final box = await _getBox<GetCartModel>(_cartBox);
                await box.clear();
                await box.put("current_cart", cart);// i use put because when hive load cart item hive will delete old cart and give me new cart item ,because cart screen  need the new cartItem not old cart items

              }

              // get cart data from cashed
              static Future<GetCartModel?>  getCachedCart()async{
                final box = await _getBox<GetCartModel>(_cartBox);
                return box.get("current_cart");

              }

              // orderHis box
              // put data in box
               static Future<void> cachedOrderHis(OrderHisModel orderHisModel)async{
                 final box =await _getBox<OrderHisModel>(_orderHisBox);
                 await box.clear();
                 await box.put("current_orders", orderHisModel);
               }

               // get data from box
               static Future<OrderHisModel?> getCachedOrders()async{
                final box = await _getBox<OrderHisModel>(_orderHisBox);
                return box.get("current_orders");
               }


               // favBox
              //put data in cached
               static Future<void> cachedFavourites(FavouritesModel favouritesModel)async{
                final box  = await _getBox<FavouritesModel>(_favBox);
                await box.clear();
                await box.put("favourites", favouritesModel);

              }

              // get data from cached
               static Future<FavouritesModel?> getCachedFav()async{
                  final box = await _getBox<FavouritesModel>(_favBox);
                  return box.get("favourites");
               }





               // black list box
               static Future <void> addToBlackList(int orderId)async{
                var box = await Hive.openBox(_blackListBox);
                await box.put(orderId,true);
               }

                // ask order del or no
              static bool isOrderDeleted(int orderId) {
                var box = Hive.box(_blackListBox);
                return box.containsKey(orderId);
              }

              static List<int> getBlacklistedIds() {
                var box = Hive.box(_blackListBox);
                return box.keys.cast<int>().toList();
              }





               // put user data in cached
                static Future<void> cachedUserData(UserModel userModel)async{
                 final box = await _getBox<UserModel>(_userDataBox);
                 await box.clear();
                 await box.put("user_data", userModel);
                }

                // get user data from cached
                static Future<UserModel?> getCachedUser()async{
                 final box = await _getBox<UserModel>(_userDataBox);
                 return box.get("user_data");
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

















