import 'dart:io';
import 'package:cheesegang/shared/widgets/error_screen.dart';
import 'package:cheesegang/features/auth/widgets/profiletxt_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../shared/widgets/costum_snakebar.dart';
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
  final _email = TextEditingController();
  final _name = TextEditingController();
  final _address = TextEditingController();
  final _visa = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _name.dispose();
    _address.dispose();
    _visa.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getProfileData();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
    listener: (context,state){
      if(state is ProfileSuccess){
        _name.text = state.userModel?.name ?? "";
        _email.text = state.userModel?.email??"";
        _address.text =state.userModel?.address?? "";
        _visa.text = state.userModel?.visa??"";
      }
      //  error when failed data
      else if (state is ProfileFailure) {
        ScaffoldMessenger.of(context).showSnackBar(customSnack(state.message??"SomeThing, went wrong"));
      }
      // action when logout
      if(state is LogOutSuccess ){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>LoginView(),));
      }
    },
    builder: (context,state) {
      final profileCubit = context.read<ProfileCubit>();
      bool isLoading = state is ProfileLoading;



        //bad connection
      if (state is ProfileFailure && profileCubit.userModel == null) {
        return ErrorScreen(
          text: state.message ?? "Check your internet, or try login again",
          buttonText: "Retry Now",
          onTap: () => profileCubit.getProfileData(),
          logButtonText: "Login again",
          log: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (e)=>LoginView()));
          }
        );
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
                          height: 120, width: 120,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade300),
                          clipBehavior: Clip.antiAlias,
                          child: profileCubit.selectImage != null
                              ? Image.file(File(profileCubit.selectImage!), fit: BoxFit.cover)
                              : (profileCubit.userModel?.image != null)
                              ? Image.network(profileCubit.userModel!.image!, fit: BoxFit.cover)
                              : const Icon(Icons.person, size: 50),
                        ),
                      ),
                      const Gap(10),
                      TextButton(
                        onPressed: isLoading ? null : profileCubit.pickImage,
                        child: const Text("Edit"),
                      ),
                      const Gap(30),

                      // الحقول (بتاخد الداتا من الـ controllers اللي اتملت في الـ Listener)
                      ProfileTextField(label: "name", controller: _name, isNumber: false),
                      const Gap(20),
                      ProfileTextField(label: "email", controller: _email, isNumber: false),
                      const Gap(20),
                      ProfileTextField(label: "Address", controller: _address, isNumber: false),
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
                        ProfileTextField(label: "visa", controller: _visa, isNumber: true),

                      const Gap(35),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _actionButton(
                            text: "Edit",
                            icon: CupertinoIcons.pencil,
                            loading: state is UpdateProfileLoading,
                            onTap: () => profileCubit.updateProfile(
                                name: _name.text,
                                email: _email.text,
                                address: _address.text,
                                visa: _visa.text
                            ),
                          ),
                          _actionButton(
                            text: "Log Out",
                            icon: Icons.logout,
                            loading: state is LogOutLoading,
                            onTap: () => profileCubit.logOut(),
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
      onTap: loading ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: AppColors.primary),
        child: loading
            ? const CupertinoActivityIndicator(color: Colors.white)
            : Row(children: [CustomText(text: text, color: Colors.white), const Gap(12), Icon(icon, color: Colors.white)]),
      ),
    );
  }


    /* return Scaffold(
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: RefreshIndicator(
              color: Colors.white,
              backgroundColor: AppColors.primary,
              onRefresh: () async => context.read<ProfileCubit>().getProfileData(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [

                    // Image Section
                    Center(
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade300,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: userState.selectImage != null
                            ? Image.file(File(userState.selectImage!), fit: BoxFit.cover)
                            : (userState.userModel?.image != null && userState.userModel!.image!.isNotEmpty)
                            ? Image.network(userState.userModel!.image!, fit: BoxFit.cover,
                            errorBuilder: (context, err, builder) =>
                            const Icon(Icons.person, size: 50))
                            : const Icon(Icons.person, size: 50),
                      ),
                    ),

                    const Gap(10),

                    // Edit Image Button
                    TextButton(
                      onPressed: context.read<ProfileCubit>().pickImage,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      child: const Text("Edit"),
                    ),
                    const Gap(30),

                    // TextFields
                    ProfileTextField(label: "name", controller: _name,isNumber: false,),
                    const Gap(20),
                    ProfileTextField(label: "email",controller: _email,isNumber: false),
                    const Gap(20),
                    ProfileTextField(label: "Delivery Address",controller: _address,isNumber: false),
                    const Gap(20),

                    // Visa Section
                    userState.userModel?.visa == null
                        ? ProfileTextField(label: "visa",controller: _visa,isNumber:true)
                        : ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      tileColor: AppColors.primary,
                      leading: Image.asset("assets/icon/visa.png", width: 50),
                      title: const CustomText(text: "Debit", color: Colors.white),
                      subtitle: CustomText(text: userState.userModel?.visa ?? "3566 **** **** 0505", color: Colors.grey.shade400),
                      trailing: const CustomText(text: "Default", color: Colors.white),
                    ),

                    const Gap(35),

                    // Action Buttons (Edit & Logout)
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Update Profile Button
                          GestureDetector(
                             onTap: () => context.read<ProfileCubit>().updateProfile(
                      name: _name.text.trim(),
                      email: _email.text.trim(),
                      address: _address.text.trim(),
                      visa: _visa.text.trim()
                    ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: AppColors.primary),
                              child: state is UpdateProfileLoading
                               ? const Row(children: [CustomText(text: "Edit", color: Colors.white), Gap(12), CupertinoActivityIndicator(color: Colors.white)])
                              :const Row(children: [CustomText(text: "Edit", color: Colors.white), Gap(12), Icon(CupertinoIcons.pencil, color: Colors.white)]),
                            ),
                          ),

                          // Logout Button
                          GestureDetector(
                            onTap: () => context.read<ProfileCubit>().logOut(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: AppColors.primary),
                              child:state is  LogOutLoading
                               ? const Row(children: [CustomText(text: "Log Out", color: Colors.white), Gap(7), CupertinoActivityIndicator(color: Colors.white)])
                            :  const Row(children: [CustomText(text: "Log Out", color: Colors.white), Gap(7), Icon(Icons.logout, color: Colors.white)]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(140),
                  ],
                ),
              ),
            ),
          ),
        ),
      );*/


    }







