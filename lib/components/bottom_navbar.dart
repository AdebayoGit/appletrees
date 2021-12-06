import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:longthroat_customer/models/cart.dart';
import 'package:longthroat_customer/utilities/app_theme.dart';
import 'package:longthroat_customer/utilities/global_variables.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> with SingleTickerProviderStateMixin {


  int selectedIndex = 0;



  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(Icons.home),
        ),
        // Todo: add a favourites screen to allow users add favourite meals and receive personalised notifications for their favourite meals
        /*IconButton(
          icon: SvgPicture.asset("assets/icons/Following.svg"),
          onPressed: () {},
        ),*/
        const BottomNavigationBarItem(
          label: 'Orders',
          icon: Icon(Icons.history),
        ),
        BottomNavigationBarItem(
          label: 'Cart',
          icon: Stack(
            children: [
              const Icon(Icons.shopping_cart),
              Positioned(
                top: 0,
                right: 0,
                child: ClipOval(
                  child: Container(
                    width: 12,
                    color: Colors.red,
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          '${cart.cart.length}',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      currentIndex: selectedIndex,
      unselectedItemColor: AppTheme.colorIcon,
      selectedItemColor: AppTheme.colorOrange,
      showUnselectedLabels: false,
      selectedLabelStyle: const TextStyle(fontSize: 12),
      type: BottomNavigationBarType.fixed,
      onTap: onItemClicked,
    );
  }

  void onItemClicked(int index){
    setState(() {
      selectedIndex = index;
      tabController.index = selectedIndex;
    });
  }
}
