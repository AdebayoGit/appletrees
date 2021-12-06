import 'package:flutter/material.dart';
import 'package:longthroat_customer/models/meal_model.dart';

import 'food_card.dart';

class MealList extends StatelessWidget {
  const MealList({
    required this.mealsList,
    Key? key,
  }) : super(key: key);

  final List<Meal> mealsList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: mealsList.length,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            MealCard(meal: mealsList[index]),
          ],
        );
      },
    );
  }
}
