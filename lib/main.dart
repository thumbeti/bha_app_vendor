import 'dart:async';

import 'package:bha_app_vendor/provider/product_provider.dart';
import 'package:bha_app_vendor/provider/vendor_provider.dart';
import 'package:bha_app_vendor/screens/add_product_screen.dart';
import 'package:bha_app_vendor/screens/home_screen.dart';
import 'package:bha_app_vendor/screens/login_screen.dart';
import 'package:bha_app_vendor/screens/on_boarding_screen.dart';
import 'package:bha_app_vendor/screens/product_screen.dart';
import 'package:bha_app_vendor/screens/vendor_edit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType = null;
  runApp(
    MultiProvider(
      providers: [
        Provider<VendorProvider>(create: (_) => VendorProvider()),
        Provider<ProductProvider>(create: (_) => ProductProvider()),
      ],
      child: MyApp(),
    ),
  );
  //runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BhaApp Vendor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: SplashScreen.id,
      home: const SplashScreen(),
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        OnBoardingScreen.id: (context) => const OnBoardingScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        ProductScreen.id: (context) => const ProductScreen(),
        AddProductScreen.id: (context) => const AddProductScreen(),
        VendorEditScreen.id: (context) => const VendorEditScreen(),
      },
      builder: EasyLoading.init(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String id = 'splash_screen';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
        const Duration(
          seconds: 3,
        ),
        () => Navigator.pushReplacementNamed(context, LoginScreen.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: AspectRatio(
          aspectRatio: 1,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                ),
                Container(
                  height: 40,
                  child: Center(
                    child:
                    Image.asset('assets/images/bha_app_logo.png'),
                  ),
                ),
                Text(
                  'Vendor',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          //child: Image.asset('assets/images/bha_app_logo.png'),
        ),
      ),
    );
  }
}
