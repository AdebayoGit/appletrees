import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:longthroat_customer/models/meal_model.dart';
import 'package:longthroat_customer/utilities/app_theme.dart';
import 'package:longthroat_customer/utilities/minor_helpers.dart';
import 'package:longthroat_customer/views/meal_details.dart';

import 'auth_components.dart';

class MealCard extends StatelessWidget {
  final Meal meal;
  const MealCard({
    Key? key,
    required this.meal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This size provide you the total height and width of the screen
    Size size = MediaQuery.of(context).size;
    // Todo: set card color based on meal type
    /*Color color = Colors.blueAccent[100]!.withOpacity(0.02);
    if (meal.mealType.toLowerCase() == 'local') {
      color = Colors.redAccent[100]!.withOpacity(0.02);
    }*/
    return Container(
      width: size.width * 0.4,
      margin: const EdgeInsets.only(left: 20, right: 15, top: 20, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 20,
            color: const Color(0xFFB0CCE1).withOpacity(0.32),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(createRoute(MealDetails(meal: meal)));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CachedNetworkImage(
                  width: size.width * 0.35,
                  color: AppTheme.primaryColor,
                  imageUrl: meal.mealImage,
                  // Display when there is an error such as 404, 500 etc.
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fadeInCurve: Curves.easeIn,
                  fadeInDuration: const Duration(milliseconds: 1000),
                  fadeOutCurve: Curves.easeOut,
                  fadeOutDuration: const Duration(milliseconds: 500),
                  imageBuilder: (context, imageProvider) => Container(
                    width: size.width * 0.5,
                    height: size.height * 0.19,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: meal.mealType.toLowerCase() == 'africana'
                            ? Colors.redAccent
                            : Colors.blueAccent,
                        width: 2.0,
                      ),
                      image: DecorationImage(
                        image: imageProvider,
                      ),
                    ),
                  ),
                  //display while fetching image.
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                          child: CircularProgressIndicator(
                              value: downloadProgress.progress)),
                ),
                FittedBox(fit: BoxFit.contain, child: Text(meal.mealName)),
                Text(
                  '${MinorHelper.getCurrency()} ${meal.mealPrice}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
