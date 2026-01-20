

         import 'package:cheesegang/features/auth/data/user_model.dart';

           abstract class ProfileState {}
            // Data States
            class ProfileInitial extends ProfileState{}
            class ProfileLoading extends ProfileState{}

           class ProfileSuccess extends ProfileState{
            final UserModel? userModel;
            final String? localImage;
             ProfileSuccess({this.userModel,this.localImage});
           }

           class ProfileGuest extends ProfileState{}
           class ProfileFailure extends ProfileState{
            final String? message;
            ProfileFailure({this.message});
           }

             //  update States

              class UpdateProfileLoading extends ProfileState{}
               class UpdateProfileSuccess extends ProfileState{
                  // to update data in screen
                  final UserModel? updateData;
                  UpdateProfileSuccess({this.updateData});
               }

              class UpdateProfileFailure extends ProfileState{
                final String? message;
                UpdateProfileFailure({this.message});
               }


             //log Out state
            class LogOutLoading extends ProfileState{}
             class LogOutSuccess extends ProfileState{}




