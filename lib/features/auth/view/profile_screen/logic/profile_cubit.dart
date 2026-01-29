import 'package:cheesegang/core/utils/pref_helper.dart';
import 'package:cheesegang/features/auth/data/auth_repo.dart';
import 'package:cheesegang/features/auth/view/profile_screen/logic/profile_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/network/api_error.dart';
import '../../../data/user_model.dart';

//S - Single Responsibility this cubit control every thing

 class  ProfileCubit extends Cubit<ProfileState> {
   final AuthRepo authRepo;
   UserModel? userModel;
   String? selectImage;
   String ? localImage;

   ProfileCubit(this.authRepo) :super(ProfileInitial());

   // i move controllers from ui to cubit
   final nameController = TextEditingController();
   final emailController = TextEditingController();
   final addressController = TextEditingController();
   final visaController = TextEditingController();

   @override
   Future<void> close() {
     nameController.dispose();
     emailController.dispose();
     addressController.dispose();
     visaController.dispose();

     return super.close();
   }
     void updateControllers(UserModel? user) {
       nameController.text = user?.name ?? "";
       emailController.text = user?.email ?? "";
       addressController.text = user?.address ?? "";
       visaController.text = user?.visa ?? "";
     }

     //Get Profile Data
     Future<void> getProfileData() async {
       final token = await PrefHelper.getToken();

       if (token == null || token.isEmpty || token == "Guest") {
         userModel = null;
         emit(ProfileGuest());
         return;
       }

       emit(ProfileLoading());

       try {
         // محاولة جلب البيانات من الـ API
         final data = await authRepo.getProfileData();

         if (data != null) {
           userModel = data;
           localImage = await PrefHelper.getUserImage(userModel!.email);
           updateControllers(userModel);
           emit(ProfileSuccess(userModel: userModel, localImage: localImage));
         } else {
           emit(ProfileFailure(message: "User data not found"));
         }
       } catch (e) {
         String errorMessage = "Bad connection, please try again.";
         emit(ProfileFailure(message: errorMessage));
       }
     }


     // load image
     Future <void> loadImage(String email) async {
       localImage = await PrefHelper.getUserImage(email);
       emit(ProfileSuccess(userModel: userModel, localImage: localImage));
     }


     //log Out
     Future<void> logOut() async {
       emit(LogOutLoading());
       try {
         await authRepo.logOut();
         emit(LogOutSuccess());
       } catch (e) {
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
         emit(ProfileSuccess(userModel: userModel, localImage: selectImage));
       } catch (e) {
         String msg = "Failed Update";
         if (e is ApiError) {
           emit(ProfileFailure(message: msg));
         }
         // if failed return to success mode
         emit(ProfileSuccess(userModel: userModel, localImage: selectImage));
       }
     }


     // pickImage
     Future<void> pickImage() async {
       try {
         final pickedImage = await ImagePicker().pickImage(
             source: ImageSource.gallery);
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









