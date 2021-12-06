import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:longthroat_customer/models/order_model.dart';

User currentUser = FirebaseAuth.instance.currentUser!;

bool menu = true;
bool specials = false;
bool desert = false;

late TabController tabController;

