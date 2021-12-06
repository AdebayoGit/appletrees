import 'package:flutter/material.dart';
import 'package:longthroat_customer/components/auth_components.dart';
import 'package:longthroat_customer/components/order_card.dart';
import 'package:longthroat_customer/models/order_model.dart';
import 'package:longthroat_customer/services/order_services.dart';
import 'package:longthroat_customer/utilities/app_theme.dart';
import 'package:longthroat_customer/views/home.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
        length: 3,
        child: Container(
          margin: EdgeInsets.only(top: size.width * 0.025),
          child: Column(
            children: [
              TabBar(
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: AppTheme.nearlyBlack,
                unselectedLabelColor: AppTheme.nearlyBlack,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: AppTheme.primaryColor, // Creates border
                ),
                tabs: [
                  Tab(
                    child: Container(
                      width: 120,
                      height: 50,
                      child: const Center(
                        child: Text(
                          'Delivered',
                        ),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              color: Colors.grey.withOpacity(0.3),
                              width: 1.0,
                          ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      width: 120,
                      height: 50,
                      child: const Center(
                        child: Text(
                          'Processing',
                        ),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              color: Colors.grey.withOpacity(0.3),
                              width: 1.0,
                          ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      width: 120,
                      height: 50,
                      child: const Center(
                        child: Text(
                          'Cancelled',
                        ),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              color: Colors.grey.withOpacity(0.3),
                              width: 1.0,
                          ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                    children: [
                      StreamBuilder<List<Order>>(
                        stream: OrderServices().orders('Delivered'),
                        initialData: const [],
                        builder: (context, AsyncSnapshot snapshot) {
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError){
                            print(snapshot.error);
                            return Center(
                              child: Column(
                                children: const [
                                  Icon(Icons.error),
                                  Text('Sorry we are unable to find any orders for you at this time'),
                                ],
                              ),
                            );
                          }
                          print(snapshot.data);
                          return OrdersList(orders: snapshot.data);
                        }
                      ),
                      StreamBuilder<List<Order>>(
                          stream: OrderServices().orders('Processing'),
                          initialData: const [],
                          builder: (context, AsyncSnapshot snapshot) {
                            if(snapshot.connectionState == ConnectionState.waiting){
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError){
                              return Center(
                                child: Column(
                                  children: const [
                                    Icon(Icons.error),
                                    Text('Sorry we are unable to find any orders for you at this time'),
                                  ],
                                ),
                              );
                            } else if(!snapshot.hasData){
                              return OrdersList(orders: snapshot.data);
                            }
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error,
                                  size: 100,
                                ),
                                Text(
                                    'Sorry we are unable to find any orders for you at this time',
                                  style: Theme.of(context).textTheme.headline6!,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            );
                          }
                      ),
                      StreamBuilder<List<Order>>(
                          stream: OrderServices().orders('Cancelled'),
                          initialData: const [],
                          builder: (context, AsyncSnapshot snapshot) {
                            if(snapshot.connectionState == ConnectionState.waiting){
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError){
                              return Center(
                                child: Column(
                                  children: const [
                                    Icon(Icons.error),
                                    Text('Sorry we are unable to find any orders for you at this time'),
                                  ],
                                ),
                              );
                            } else if(!snapshot.hasData){
                              return OrdersList(orders: snapshot.data);
                            }
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error,
                                  size: 100,
                                ),
                                Text(
                                  'Sorry we are unable to find any orders for you at this time',
                                  style: Theme.of(context).textTheme.headline6!,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            );
                          }
                      ),
                    ],
                ),
              ),
            ],
          ),
        ),
    );
  }
}
