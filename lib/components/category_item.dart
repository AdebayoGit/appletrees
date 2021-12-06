import 'package:flutter/material.dart';
import 'package:longthroat_customer/utilities/app_theme.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback press;
  const CategoryItem({
    Key? key,
    required this.title,
    this.isActive = false,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: press,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: <Widget>[
            Text(
              title,
              style: isActive
                  ? const TextStyle(
                color: AppTheme.textColor,
                fontWeight: FontWeight.bold,
              )
                  : const TextStyle(fontSize: 12),
            ),
            if (isActive)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                height: 3,
                width: 22,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
