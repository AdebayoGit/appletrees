import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:longthroat_customer/views/drawer.dart';
import 'package:longthroat_customer/views/home.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const String id = 'main';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: const [
          DrawerScreen(),
          HomeScreen(),
        ],
      ),
    );
  }
}
