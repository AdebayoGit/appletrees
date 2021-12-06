import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:longthroat_customer/models/order_model.dart';
import 'package:longthroat_customer/utilities/app_theme.dart';
import 'package:longthroat_customer/utilities/minor_helpers.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({required this.order, Key? key}) : super(key: key);

  final Order order;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      //color: AppTheme.primaryColor,
      margin: EdgeInsets.symmetric(vertical: size.height * 0.01, horizontal: size.width * 0.04),
      shadowColor: AppTheme.nearlyBlack,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: size.height * 0.03, horizontal: size.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                    'Order No ${order.orderNo}',
                  style: GoogleFonts.lato(
                    textStyle: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  order.time.split(' ')[0],
                  style: GoogleFonts.lato(
                    textStyle: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: size.height * 0.03),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Tracking ID: ",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!.copyWith(color: AppTheme.textColor),
                    ),
                    TextSpan(
                      text: order.id,
                      style: Theme.of(context)
                          .textTheme.subtitle1!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Quantity: ",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!.copyWith(color: AppTheme.textColor),
                      ),
                      TextSpan(
                        text: "${order.local + order.continental}",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Total Amount: ",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!.copyWith(color: AppTheme.textColor),
                      ),
                      TextSpan(
                        text: "${MinorHelper.getCurrency()} ${order.amount}",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      shape: const StadiumBorder(side: BorderSide(color: AppTheme.nearlyBlack)),
                      primary: AppTheme.primaryColor
                    ),
                    onPressed: (){},
                    child: const Text(
                      'Details',
                      style: TextStyle(
                          color: AppTheme.primaryColor,
                          letterSpacing: 5,
                          wordSpacing: 3,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Text(
                    order.status,
                    style: TextStyle(
                      color: getStatusColor(),
                      fontSize: 20,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Color getStatusColor(){
    if(order.status.toLowerCase() == 'delivered'){
      return Colors.green;
    } else if (order.status.toLowerCase() == 'cancelled'){
      return Colors.red;
    } else {
      return Colors.yellow;
    }
  }
}


class OrdersList extends StatelessWidget {
  const OrdersList({required this.orders, Key? key}) : super(key: key);

  final List<Order> orders;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (BuildContext context, int index) {
        return OrderCard(order: orders[index]);
      },
    );
  }
}

