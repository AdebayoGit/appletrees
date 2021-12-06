import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:longthroat_customer/components/notification_dialog.dart';
import 'package:longthroat_customer/utilities/app_theme.dart';
import 'package:longthroat_customer/views/main_page.dart';
import 'package:longthroat_customer/views/ratings_review.dart';
import 'package:longthroat_customer/views/sign_in.dart';
import 'package:provider/provider.dart';

import 'models/cart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Cart>(
      create: (context) => Cart(),
      child: MaterialApp(
          title: 'Apple Trees',
          theme: ThemeData(
            primarySwatch: Colors.orange,
            primaryColor: AppTheme.primaryColor,
            scaffoldBackgroundColor: Colors.white,
            textTheme: const TextTheme(
              bodyText1: TextStyle(color: AppTheme.secondaryColor),
              bodyText2: TextStyle(color: AppTheme.secondaryColor),
            ),
          ),
          home: const SplashScreen(),
          routes: {
            MainScreen.id: (context) => const MainScreen(),
            SignIn.id: (context) => const SignIn(),
            Ratings.id: (context) => const Ratings(),
          },
        ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () => homeWidget(user));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFC61F),
      body: Container(
        padding: const EdgeInsets.all(100.0),
        child: const SpinKitDoubleBounce(
          color: Colors.orange,
          size: 50.0,
        ),
      ),
    );
  }

  homeWidget(User? user) {
    if (user != null) {
      return Navigator.pushNamedAndRemoveUntil(context, MainScreen.id, (_) => false);
    } else {
      return Navigator.pushNamedAndRemoveUntil(context, SignIn.id, (_) => false);
    }
  }
}


class Init {
  Init._();
  static final instance = Init._();
  Future initialize() async {
    await Future.delayed(const Duration(seconds: 3));
    return FirebaseAuth.instance.currentUser;
  }
}