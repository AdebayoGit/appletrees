import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MinorHelper{

  static void showSnackBar(String title, BuildContext context){
    final snackbar = SnackBar(
      content: Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15),),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  static String getCurrency() {
    var format = NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'NGN');
    return format.currencySymbol;
  }
}