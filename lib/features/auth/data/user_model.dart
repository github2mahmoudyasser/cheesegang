// كلاس او قالب لشكل معلومات او البيانات اللي جاية من السيرفر
//هو اللي بيحوّل بيانات الـ API لشكل منظم تقدر تستخدمه في الابلكيشن.


import 'package:hive_ce/hive.dart';
part 'user_model.g.dart';
           @HiveType(typeId: 7)
          class UserModel{

             @HiveField(0)
           final String name;

             @HiveField(1)
             final String email;

             @HiveField(2)
              String? image;

             @HiveField(3)
             final String? token;

             @HiveField(4)
             final String? address;

             @HiveField(5)
             final String? visa;


              UserModel({
               required this.name,
                required this.email,
                this.image,
                this.token,
                this.address,
                this.visa

        });
               factory UserModel.fromJson(Map<String,dynamic>json){


                 return UserModel(
                     name: json["name"],
                      email: json["email"] ,
                      image: json["image"] ,
                      token: json["token"] ,
                      address: json["address"] ,
                      visa: json["Visa"] ,




                  );
           }





        }










