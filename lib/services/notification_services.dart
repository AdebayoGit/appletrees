import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:longthroat_customer/components/progress_dialog.dart';

class NotificationServices{

  final FirebaseMessaging fcm = FirebaseMessaging.instance;
  Future initialize(context) async{

    fcm.getInitialMessage().then((message) {
      if (message != null) {
        print(message.data);
      }
    });

    FirebaseMessaging.onMessage.listen((message) {
      notificationHelper(message, context);

    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      notificationHelper(message, context);
    });

  }


  notificationHelper(dynamic message, BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return const ProgressDialog(status: 'Please wait');
        }
    );
    late String type;

    if(Platform.isAndroid){
      type = message.data['notification_type'];
    }
    else{
      type = message['notification_type'];
    }

    if(type == 'rating'){
      showDialog(
          context: context,
          builder: (BuildContext context){
            return Container();
          },
      );
    }

  }

}