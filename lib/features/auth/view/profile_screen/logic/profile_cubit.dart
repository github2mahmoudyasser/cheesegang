import 'package:cheesegang/core/utils/pref_helper.dart';
import 'package:cheesegang/features/auth/data/auth_repo.dart';
import 'package:cheesegang/features/auth/view/profile_screen/logic/profile_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/network/api_error.dart';
import '../../../data/user_model.dart';

 class  ProfileCubit extends Cubit<ProfileState> {
   final AuthRepo authRepo;
   UserModel? userModel;
   String? selectImage;
   String ? localImage;

   ProfileCubit(this.authRepo) :super(ProfileInitial());

   //Get Profile Data
   Future<void> getProfileData() async {
     // 1. أولاً: نتحقق من وجود التوكن (ده الفيصل بين اليوزر والجيست)
     final token = await PrefHelper.getToken();

     if (token == null || token.isEmpty || token == "Guest") {
       userModel = null;
       emit(ProfileGuest()); // هنا بس يروح لصفحة "سجل دخول"
       return;
     }

     // 2. ثانياً: لو فيه توكن، نبدأ التحميل (User Mode)
     emit(ProfileLoading());

     try {
       // محاولة جلب البيانات من الـ API
       final data = await authRepo.getProfileData();

       if (data != null) {
         userModel = data;
         localImage = await PrefHelper.getUserImage(userModel!.email);
         emit(ProfileSuccess(userModel: userModel,localImage: localImage));
       } else {
         // لو السيرفر رد بـ null رغم وجود توكن (مشكلة في الحساب)
         emit(ProfileFailure(message: "User data not found"));
       }
     } catch (e) {
       // 3. ثالثاً: لو حصل مشكلة في النت (DioException أو غيره)
       // هنا بنبعت Failure عشان الـ UI يظهر شاشة الـ Error مش الـ Guest
       String errorMessage = "Bad connection, please try again.";

       // لو بتستخدم Dio ومسوي له Handler زي الـ Products
       /*
    if (e is DioException) {
      errorMessage = ApiExceptions.handleError(e).toString();
    }
    */

       emit(ProfileFailure(message: errorMessage));
     }
   }


    // load image
   Future <void> loadImage(String email)async{
   localImage= await PrefHelper.getUserImage(email);
   emit(ProfileSuccess(userModel: userModel,localImage: localImage));
   }



     //log Out
  Future<void> logOut()async{
     emit(LogOutLoading());
       try{
         await authRepo.logOut();
         emit(LogOutSuccess());
       }catch(e){
         String msg = "Success to LogOut";
        debugPrint(msg);
         emit(LogOutSuccess());
       }

  }

       //update profile
   Future<void> updateProfile({
   required String name,
   required String email,
   required String address,
   required String visa,
   }) async {
   if (userModel == null) return;

   emit(UpdateProfileLoading());
   try {
   final updatedData = await authRepo.updateProfile(
   name: name,
   email: email,
   address: address,
   imagePath: selectImage,
   visa: visa,
   );

   userModel = updatedData;
   emit(ProfileSuccess(userModel: userModel,localImage: selectImage));
   } catch (e) {
     String msg = "Failed Update";
     if(e is ApiError){
       emit(ProfileFailure(message: msg));
     }
     // if failed return to success mode
   emit(ProfileSuccess(userModel: userModel, localImage: selectImage));
   }
   }


   // pickImage
   Future<void> pickImage() async {
     try {
       final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
       if (pickedImage != null && userModel?.email != null) {
         selectImage = pickedImage.path;
         await PrefHelper.saveUserImage(userModel!.email, pickedImage.path);

         emit(ProfileSuccess(userModel: userModel, localImage: selectImage));
       }
     } catch (e) {
       emit(ProfileFailure(message: "Failed to pick image"));
     }
   }

 }









