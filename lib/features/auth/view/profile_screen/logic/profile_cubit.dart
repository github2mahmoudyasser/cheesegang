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

   ProfileCubit(this.authRepo) :super(ProfileInitial());

   //Get Profile Data
   Future<void> getProfileData() async {
     emit(ProfileLoading());

     // 1. لو هو داخل Guest من البداية
     if (authRepo.isGuest) {
       emit(ProfileGuest());
       return;
     }

     try {
       userModel = await authRepo.autoLogin();

       if (userModel != null) {
         // نجاح في جلب البيانات
         if (userModel?.email != null) {
           selectImage = await PrefHelper.getUserImage(userModel!.email);
         }
         emit(ProfileSuccess(userModel: userModel, localImage: selectImage));
       } else {
         // البيانات null يعني الـ Token مش موجود أو انتهى
         emit(ProfileGuest());
       }
     } catch (e) {
       // 2. هنا الحل: لو حصل خطأ (نت مثلاً)
       String msg = "Bad Connection. Please try again.";
       if (e is ApiError) msg = e.message;

       // لو النت قطع ومعانا داتا قديمة، نفضل عارضينها (Success)
       if (userModel != null) {
         emit(ProfileSuccess(userModel: userModel, localImage: selectImage));
       } else {
         // لو مفيش داتا خالص، اظهر حالة الفشل (عشان تعرض أيقونة النت في الشاشة)
         emit(ProfileFailure(message: msg));
       }
     }
   }

     //log Out
  Future<void> logOut()async{
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









