import 'dart:async';

import 'package:e_commerce/app/controllers/TextFieldController.dart';
import 'package:e_commerce/app/controllers/account/login_controller.dart';
import 'package:e_commerce/app/controllers/account/forgotPassword.dart';
import 'package:e_commerce/app/controllers/account/signup_controller.dart';
import 'package:e_commerce/app/controllers/auth/authService.dart';
import 'package:e_commerce/app/controllers/cartController/cart_item_controller.dart';
import 'package:e_commerce/app/controllers/cartController/cart_controller.dart';
import 'package:e_commerce/app/controllers/bottomItemController.dart';
import 'package:e_commerce/app/controllers/chat/chatService.dart';
import 'package:e_commerce/app/controllers/detailsProduct/CoffeeSizeController.dart';
import 'package:e_commerce/app/controllers/favoriteController.dart';
import 'package:e_commerce/app/controllers/paymentController/payment_controller.dart';
import 'package:e_commerce/app/controllers/sanphamController.dart';
import 'package:e_commerce/app/controllers/user/user_controller.dart';
import 'package:e_commerce/app/view/chatbasic/chatRoom.dart';
import 'package:e_commerce/app/view/chatbasic/chatapp.dart';
import 'package:e_commerce/app/view/screens/test/Account.dart';
import 'package:e_commerce/app/view/screens/test/Cart.dart';
import 'package:e_commerce/app/view/screens/test/DetailsProduct.dart';
import 'package:e_commerce/app/view/screens/test/Favorite.dart';
import 'package:e_commerce/app/view/screens/test/Payment/Payment.dart';
import 'package:e_commerce/app/view/screens/test/Payment/PaymentSuccess.dart';
import 'package:e_commerce/app/view/screens/test/Payment/WebViewPayment.dart';
import 'package:e_commerce/app/view/screens/test/Profile/Personal%20Information.dart';
import 'package:e_commerce/app/view/screens/test/Profile/Profile.dart';
import 'package:e_commerce/app/view/chatbasic/chatScreen.dart';
import 'package:e_commerce/app/view/screens/test/home.dart';
import 'package:e_commerce/app/view/screens/MainScreen.dart';
import 'package:e_commerce/utils/constants/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uni_links/uni_links.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(AuthService());
  Get.put(ChatService());
  Get.put(UserController());
  Get.put(CartController());
  Get.put(Bottomitemcontroller());
  Get.put(SanPhamController());
  Get.put(Cartitemcontroller());
  Get.put(CoffeeSizeController());
  Get.put(FavoriteController());
  Get.put(PaymentController());
  Get.put(TextFieldController());
  Get.put(SignupController());
  Get.put(LoginController());

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initDeepLink();
  }

  StreamSubscription? sub;
  void initDeepLink() async {
    if (kIsWeb) {
      return;
    }
    Uri? initialUri = await getInitialUri();
    sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        if (uri.scheme == "coffeeapp" && uri.host == "payment_callback") {
          Get.toNamed("/payment-success");
        }
      } else
        print("URI null");
    }, onError: (e) {
      print("Deeplink errorr $e");
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: appTheme.lightTheme,
      darkTheme: appTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const Account(),
      getPages: [
        GetPage(name: '/home', page: () => const HomePage()),
        GetPage(name: '/details', page: () => DetailsProduct()),
        GetPage(
          name: '/cart',
          page: () => Cart(),
        ),
        GetPage(
          name: '/profile',
          page: () => Profile(),
        ),
        GetPage(
          name: '/updateprofile',
          page: () => PersonalInformation(),
        ),
        GetPage(
          name: '/favorite',
          page: () => Favorite(),
        ),
        GetPage(
          name: '/mainScreen',
          page: () => const MainScreen(),
        ),
        GetPage(
          name: '/payment',
          page: () => Payment(),
        ),
        GetPage(
          name: '/payment-success',
          page: () => PaymentSuccess(),
        ),
        GetPage(name: '/account', page: () => const Account()),
        GetPage(name: '/forgotpassword', page: () => ForgotPassWord()),
        GetPage(
          name: '/userchat',
          page: () => UserChat(),
        ),
        GetPage(
          name: '/chat',
          page: () => const ChatApp(),
        ),
        GetPage(
          name: '/chatroom',
          page: () => Chatroom(),
        )
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
