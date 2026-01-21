
import 'package:cheesegang/features/Root/logic/root_cubit.dart';
import 'package:cheesegang/features/auth/view/login_screen/logic/login_cubit.dart';
import 'package:cheesegang/features/auth/view/profile_screen/logic/profile_cubit.dart';
import 'package:cheesegang/features/auth/view/sign_screen/logic/signup_cubit.dart';
import 'package:cheesegang/features/cart/data/cart_repo.dart';
import 'package:cheesegang/features/home/views/logic/home_cubid.dart';
import 'package:cheesegang/features/product/data/details_model.dart';
import 'package:cheesegang/features/product/repo/details_repo.dart';
import 'package:cheesegang/features/product/views/logic/product_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/navigation/app_navigator.dart';
import 'core/network/api_service.dart';
import 'features/auth/data/auth_repo.dart';
import 'features/home/data/models/product_model.dart';
import 'features/home/data/repo/product_repo.dart';
import 'features/splash_screen/view/logic/splash_cubit.dart';
import 'features/splash_screen/view/ui_view/splash.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // إخفاء الـ bars بالكامل
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  // Init Hive
  await Hive.initFlutter(); // to ask system do you give me space to put my data
  Hive.registerAdapter(ProductModelAdapter());
  Hive.registerAdapter(DetailsModelAdapter()); // Hive now under stand detail model
  await Hive.openBox<ProductModel>('productsBox');
  await Hive.openBox<DetailsModel>('toppingsBox'); // Initialization box when open app
  await Hive.openBox("userBox");// open the box fast to get token and image

  // 1. تجهيز الـ API والـ Repo
  final apiService = ApiService();
  final authRepo = AuthRepo(apiService);
  final toppingRepo  = DetailsRepo(apiService);
   final productRepo = ProductRepo(apiService);
   final cartRepo = CartRepo(apiService);



  runApp(   // we put Repos here because protect Ram from building repo when open or close screens
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepo),
        RepositoryProvider.value(value: productRepo),
        RepositoryProvider.value(value: toppingRepo),
        RepositoryProvider.value(value: cartRepo),
      ],
      child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context)=>SplashCubit(RepositoryProvider.of<AuthRepo>(context)),),
            BlocProvider(create: (context)=>LoginCubit(RepositoryProvider.of<AuthRepo>(context)),),
            BlocProvider(create: (context)=>SignupCubit(RepositoryProvider.of<AuthRepo>(context)),),
            BlocProvider(create: (context)=>ProfileCubit(RepositoryProvider.of<AuthRepo>(context)),),
            BlocProvider(create: (context)=>RootCubit(),),
            BlocProvider(create: (context)=>HomeCubit(RepositoryProvider.of<ProductRepo>(context)),),
            BlocProvider(create: (context)=>ProductDetailsCubit(RepositoryProvider.of<DetailsRepo>(context),RepositoryProvider.of<CartRepo>(context)),),
            //BlocProvider(create: (context)=>FavCubit(RepositoryProvider.of<FavRepo>(context)),),
          //  BlocProvider(create: (context)=>OrderHisCubit(RepositoryProvider.of<OrderHisRepo>(context)),),
          ],
          child: const MyApp())
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'cheese gang',
        home: SplashView()
      );

  }
}


