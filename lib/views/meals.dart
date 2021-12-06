import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:longthroat_customer/components/category_item.dart';
import 'package:longthroat_customer/components/discount_card.dart';
import 'package:longthroat_customer/components/meals_list.dart';
import 'package:longthroat_customer/models/meal_model.dart';
import 'package:longthroat_customer/services/meal_services.dart';
import 'package:longthroat_customer/utilities/app_theme.dart';
import 'package:longthroat_customer/utilities/global_variables.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({Key? key}) : super(key: key);

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: FittedBox(
              alignment: Alignment.centerLeft,
              child: Text(
                'Delicious dishes\nJust for you ...',
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                      letterSpacing: 1.0,
                      fontSize: 40.0,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                      color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CategoryItem(
                    title: "Menu",
                    isActive: menu,
                    press: () {
                      setState(() {
                        menu = true;
                        specials = false;
                        desert = false;
                      });
                    },
                  ),
                  CategoryItem(
                    title: "Specials",
                    isActive: specials,
                    press: () {
                      setState(() {
                        menu = false;
                        specials = true;
                        desert = false;
                      });
                    },
                  ),
                  CategoryItem(
                    title: "Deserts",
                    isActive: desert,
                    press: () {
                      setState(() {
                        menu = false;
                        specials = false;
                        desert = true;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          if (menu) ...[
            SizedBox(
              height: 275,
              child: Column(
                children: [
                  Text(
                    'Today\'s menu',
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<List<Meal>>(
                        initialData: const [],
                        stream: MealServices().shop,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return MealList(mealsList: snapshot.data!);
                          } else if (!snapshot.hasData) {
                            return const Center(
                                child:
                                Text('There are no meals available'));
                          } else {
                            return const Text(
                                'There are no meals available');
                          }
                        }),
                  ),
                ],
              ),
            ),
          ],
          if (specials) ...[
            SizedBox(
              height: 275,
              child: Column(
                children: [
                  Text(
                    'Special menu',
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<List<Meal>>(
                        initialData: const [],
                        stream: MealServices().shop,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return MealList(mealsList: snapshot.data!);
                          } else if (!snapshot.hasData) {
                            return const Center(
                                child: Text(
                                    'There are no special meals today'));
                          } else {
                            return const Text(
                                'There are no meals available');
                          }
                        }),
                  ),
                ],
              ),
            ),
          ],
          if (desert) ...[
            SizedBox(
              height: 275,
              child: Column(
                children: [
                  Text(
                    'Desert of the Day',
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<List<Meal>>(
                        initialData: const [],
                        stream: MealServices().shop,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return MealList(mealsList: snapshot.data!);
                          } else if (!snapshot.hasData) {
                            return const Center(
                                child:
                                Text('There are no deserts today'));
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else {
                            return const Text(
                                'There are no meals available');
                          }
                        }),
                  ),
                ],
              ),
            ),
          ],
          const DiscountCard(),
        ],
      ),
    );
  }
}
