import 'dart:io';
import 'package:cheesegang/features/cart/views/logic/cart_cubit.dart';
import 'package:cheesegang/features/favourites/view/logic/fav_cubit.dart';
import 'package:cheesegang/features/home/views/logic/home_cubid.dart';
import 'package:cheesegang/shared/widgets/error_screen.dart';
import 'package:cheesegang/features/auth/widgets/profiletxt_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/pref_helper.dart';
import '../../../../../shared/widgets/costum_text.dart';
import '../../login_screen/ui_view/login_view.dart';
import '../logic/profile_cubit.dart';
import '../logic/profile_state.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getProfileData();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
    builder: (context,state) {
      final profileCubit = context.read<ProfileCubit>();
      final user = profileCubit.userModel;

      bool isLoading = state is ProfileLoading;




        //bad connection
      if (state is ProfileFailure ) {
        return ErrorScreen(
          text:  "Check your internet",
          buttonText: "Retry Now",
          onTap: () => profileCubit.getProfileData(),

        );
      }

      // guest mode
      if (state is ProfileGuest) {
        return _buildGuestView(context);
      }



      // main profile Screen
      return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Center(
            child: CustomText(
              text: "cheese Gang!",
              size: 40,
              fontFamily: GoogleFonts.luckiestGuy().fontFamily,
              color: AppColors.primary,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: Skeletonizer(
            enabled: isLoading,
            child: RefreshIndicator(
              onRefresh: () async => profileCubit.getProfileData(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade300),
                          clipBehavior: Clip.antiAlias,
                          child: profileCubit.selectImage != null
                              ? Image.file(File(profileCubit.selectImage!), fit: BoxFit.cover)
                               :(profileCubit.localImage !=null)
                              ? Image.file(File(profileCubit.localImage!), fit: BoxFit.cover)
                              : const Icon(Icons.person, size: 50),
                        ),
                      ),
                      const Gap(10),
                      TextButton(
                        onPressed: isLoading ? null : profileCubit.pickImage,
                        child: const Text("Edit"),
                      ),
                      const Gap(30),

                      ProfileTextField(
                          label: "name",
                          controller: context.read<ProfileCubit>().nameController,
                          isNumber: false),
                      const Gap(20),
                      ProfileTextField(
                          label: "email",
                          controller: context.read<ProfileCubit>().emailController,
                          isNumber: false),
                      const Gap(20),
                      ProfileTextField(
                          label: "Address",
                          controller: context.read<ProfileCubit>().addressController,
                          isNumber: false),
                      const Gap(20),

                      // في حالة التحميل أو وجود فيزا
                      if (profileCubit.userModel?.visa != null || isLoading)
                        ListTile(
                          tileColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          leading: const Icon(Icons.credit_card, color: Colors.white),
                          title: const Text("Debit Card", style: TextStyle(color: Colors.white)),
                          subtitle: Text(profileCubit.userModel?.visa ?? "**** **** **** ****", style: TextStyle(color: Colors.white70)),
                        )
                      else
                        ProfileTextField(
                            label: "visa",
                            controller:context.read<ProfileCubit>().visaController,
                            isNumber: true),

                      const Gap(35),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _actionButton(
                            text: "Update",
                            icon: CupertinoIcons.pencil,
                            loading: state is UpdateProfileLoading,
                            onTap: (){
                              final profileCubit = context.read<ProfileCubit>();
                              profileCubit.updateProfile(
                                  name: profileCubit.nameController.text,
                                  email: profileCubit.emailController.text,
                                  address: profileCubit.nameController.text,
                                  visa: profileCubit.visaController.text
                              );
                            }
                          ),
                          Gap(8),
                          _actionButton(
                            text: "Log Out",
                            icon: Icons.logout,
                            loading: state is LogOutLoading,
                            onTap: ()async {
                              await profileCubit.logOut();
                              await PrefHelper.logout();
                              if (!context.mounted) return;
                              context.read<HomeCubit>().clearHomeData(); // to reset home state to initial when log out
                              context.read<CartCubit>().clearCartData();
                              context.read<FavCubit>().clearFavData();
                            }
                          ),
                        ],
                      ),
                      const Gap(140),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
    );
  }

  Widget _actionButton({required String text, required IconData icon, required bool loading, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: loading ? null : onTap, // disabled click when loading
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: AppColors.primary),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          CustomText(text: text,
              color: Colors.white),
          const Gap(12),
          loading
          ?CupertinoActivityIndicator(
            color: Colors.white,
            radius: 8,
          )
          :Icon(icon, color: Colors.white)]),
      ),
    );
  }

  Widget _buildGuestView(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, centerTitle: true, title: const Text("Profile")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.account_circle_outlined, size: 120, color: AppColors.primary.withOpacity(0.5)),
              const Gap(20),
              CustomText(text: "You are browsing as a Guest", size: 20, color: Colors.black),
              const Gap(10),
              const Text("Login now to see your profile and track orders", textAlign: TextAlign.center),
              const Gap(30),
              _actionButton(
                text: "Login / Sign Up",
                icon: Icons.login,
                loading: false,
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (e) => const LoginView()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }




    }







