import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:longthroat_customer/components/auth_components.dart';
import 'package:longthroat_customer/components/checkout_card.dart';
import 'package:longthroat_customer/models/cart.dart';
import 'package:longthroat_customer/models/meal_model.dart';
import 'package:longthroat_customer/services/meal_services.dart';
import 'package:longthroat_customer/views/check_out_steps.dart';
import 'package:provider/provider.dart';

import 'main_page.dart';

class CheckOut extends StatefulWidget {
  const CheckOut({Key? key}) : super(key: key);

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  int badge = 0;


  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      floatingActionButton: Button(
        press: () {
          if(cart.cart.isNotEmpty){
            Navigator.of(context).push(createRoute(const CheckOutSteps()));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
              content: Center(
                child: Text(
                    'Please add meals to proceed'
                ),
              ),
                  dismissDirection: DismissDirection.horizontal,
            ));
            Navigator.pushNamed(context, MainScreen.id);
          }

        },
        color: Colors.orange,
        title: 'Proceed To Checkout',
        textColor: Colors.orange,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: StreamBuilder<List<Meal>>(
              initialData: const [],
              stream: MealServices().shop,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Container());
                } else if (snapshot.data == null) {
                  return const Text('iii');
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitDoubleBounce(
                      color: Colors.orange,
                      size: 50.0,
                    ),
                  );
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.all(0),
                    physics: const BouncingScrollPhysics(),
                    //shrinkWrap: true,
                    itemCount: cart.cart.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                          key: UniqueKey(),
                          onDismissed: (direction) {
                            String name = cart.cart.elementAt(index).mealName;
                            resetCount(index, cart);
                            cart.removeFromCart(cart.cart.elementAt(index));
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                '$name was removed',
                                textAlign: TextAlign.center,
                              ),
                            ));
                          },
                          child:
                              CheckOutCard(meal: cart.cart.elementAt(index)));
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void resetCount(int index, Cart cart) {
    if (cart.cart.elementAt(index).mealType.toLowerCase() == 'africana') {
      cart.local = 0;
    } else {
      cart.continental = 0;
    }
  }
}
