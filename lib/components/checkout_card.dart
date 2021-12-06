import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:longthroat_customer/models/cart.dart';
import 'package:longthroat_customer/models/meal_model.dart';
import 'package:provider/provider.dart';

class CheckOutCard extends StatefulWidget {
  final Meal meal;
  const CheckOutCard({Key? key, required this.meal}) : super(key: key);

  @override
  State<CheckOutCard> createState() => _CheckOutCardState();
}

class _CheckOutCardState extends State<CheckOutCard> {
  int badge = 0;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final cart = Provider.of<Cart>(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
      child: Card(
        shadowColor: widget.meal.mealType.toLowerCase() == 'africana'
            ? Colors.red
            : Colors.blue,
        elevation: 5,
        child: SizedBox(
          height: size.height * 0.2,
          child: Row(
            children: [
              Container(
                width: size.width * 0.5,
                height: size.height * 0.19,
                margin: const EdgeInsets.only(left: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: widget.meal.mealType.toLowerCase() == 'africana'
                        ? Colors.redAccent
                        : Colors.blueAccent,
                    width: 2.0,
                  ),
                  image: DecorationImage(
                    image: NetworkImage(widget.meal.mealImage),
                    fit: BoxFit.fill,
                    scale: 0.6,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: size.width * 0.05),
                width: size.width * 0.42,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            widget.meal.mealType.toUpperCase(),
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: widget.meal.mealType.toLowerCase() == 'africana'
                                    ? Colors.redAccent
                                    : Colors.blueAccent,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: size.height * 0.001,
                              right: size.width * 0.01,
                            ),
                            child: Text(
                              '${getCurrency()} ${widget.meal.mealPrice}',
                              style: TextStyle(
                                color: Colors.green[200],
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          widget.meal.mealName,
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(17.0),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    IconButton(
                                      onPressed: () {
                                        cart.decrease(widget.meal);
                                      },
                                      icon: Container(
                                        height: 15.0,
                                        width: 15.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(4.0),
                                          color: Colors.orangeAccent,
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.remove,
                                            color: Colors.white,
                                            size: 12.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      widget.meal.mealType.toLowerCase() == 'africana' ? '${cart.local}' : '${cart.continental}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.orange,
                                        fontFamily: 'Montserrat',
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        cart.increase(widget.meal);
                                      },
                                      icon: Container(
                                        height: 15.0,
                                        width: 15.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(4.0),
                                          border: Border.all(color: Colors.orange),
                                          color: Colors.white,
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.orange,
                                            size: 12.0,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getCurrency() {
    var format =
    NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'NGN');
    return format.currencySymbol;
  }
}
