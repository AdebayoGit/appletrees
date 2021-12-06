import 'package:flutter/material.dart';
import 'package:longthroat_customer/components/item_image.dart';
import 'package:longthroat_customer/components/order_button.dart';
import 'package:longthroat_customer/components/title_price_rating.dart';
import 'package:longthroat_customer/models/cart.dart';
import 'package:longthroat_customer/models/meal_model.dart';
import 'package:longthroat_customer/utilities/app_theme.dart';
import 'package:provider/provider.dart';

class MealDetails extends StatelessWidget {
  const MealDetails({required this.meal, Key? key}) : super(key: key);

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      backgroundColor: Colors.orange,
      /*appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: SvgPicture.asset("assets/icons/share.svg"),
            onPressed: () {},
          ),
          IconButton(
            icon: SvgPicture.asset("assets/icons/more.svg"),
            onPressed: () {},
          ),
        ],
      ),*/
      
      floatingActionButton: OrderButton(
        size: size,
        press: () {
          cart.addToCart(meal);
          Navigator.of(context).pop();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Stack(
              children: [
                ItemImage(
                  imgSrc: meal.mealImage,
                ),
                Positioned(
                  child: IconButton(
                  icon: const CircleAvatar(
                    minRadius: 20,
                    backgroundColor: Colors.orange,
                    child: Icon(
                      Icons.arrow_back_outlined,
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),)
              ],
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    mealType(type: meal.mealType),
                    TitlePriceRating(
                      name: meal.mealName,
                      //numOfReviews: 24,
                      //rating: 4,
                      price: meal.mealPrice,
                      onRatingChanged: (value) {},
                    ),
                    Text(
                      meal.mealDesc,
                      style: const TextStyle(
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: size.height * 0.1),
                    // Free space  10% of total height
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row mealType({required String type}) {
    return Row(
      children: <Widget>[
        const Icon(
          Icons.location_on,
          color: AppTheme.secondaryColor,
        ),
        const SizedBox(width: 10),
        Text(type.toUpperCase()),
      ],
    );
  }
}
