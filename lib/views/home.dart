import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:longthroat_customer/components/bottom_navbar.dart';
import 'package:longthroat_customer/components/checkout_card.dart';
import 'package:longthroat_customer/utilities/app_theme.dart';
import 'package:longthroat_customer/utilities/global_variables.dart';
import 'package:longthroat_customer/views/meals.dart';
import 'package:longthroat_customer/views/orders.dart';

import 'check_out.dart';
import 'check_out_steps.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String id = 'Home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        setState(() {
          xOffset = 0;
          yOffset = 0;
          scaleFactor = 1;
          isDrawerOpen = false;
        });
      },
      onDoubleTap: (){
        setState(() {
          xOffset = 230;
          yOffset = 150;
          scaleFactor = 0.6;
          isDrawerOpen = true;
        });
      },
      child: AnimatedContainer(
        transform: Matrix4.translationValues(xOffset, yOffset, 0)..scale(scaleFactor),
        duration: const Duration(milliseconds: 500),
        color: Colors.white,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: isDrawerOpen ? IconButton(
                onPressed: (){
                  setState(() {
                    xOffset = 0;
                    yOffset = 0;
                    scaleFactor = 1;
                    isDrawerOpen = false;
                  });
                },
                icon: const Icon(Icons.arrow_back),
            )
            : IconButton(
              icon: SvgPicture.asset("assets/icons/menu.svg"),
              onPressed: () {
                setState(() {
                  xOffset = 230;
                  yOffset = 150;
                  scaleFactor = 0.6;
                  isDrawerOpen = true;
                });
              },
            ),
            title: RichText(
              text: TextSpan(
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontWeight: FontWeight.bold),
                children: const [
                  TextSpan(
                    text: "Apple",
                    style: TextStyle(color: AppTheme.secondaryColor),
                  ),
                  TextSpan(
                    text: "Trees",
                    style: TextStyle(color: AppTheme.primaryColor),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: SvgPicture.asset("assets/icons/notification.svg"),
                onPressed: () {},
              ),
            ],
          ),
          bottomNavigationBar: const BottomNavBar(),
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: tabController,
            children: const <Widget>[
              MealsScreen(),
              OrdersScreen(),
              CheckOut(),
            ],
          ),
        ),
      ),
    );
  }


}
