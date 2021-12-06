import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:connectivity/connectivity.dart';


import 'package:longthroat_customer/components/auth_components.dart';
import 'package:longthroat_customer/components/progress_dialog.dart';
import 'package:longthroat_customer/utilities/app_theme.dart';
import 'package:longthroat_customer/utilities/validator.dart';

import 'main_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final picker = ImagePicker();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController dobController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ImageWidget(
              onClicked: (){
                showModalBottomSheet(
                    context: context,
                    builder: (context){
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                              onPressed: () => pickImage(ImageSource.camera),
                              child: const Text('From Camera'),
                          ),
                          TextButton(
                            onPressed: () => pickImage(ImageSource.gallery),
                            child: const Text('From Gallery'),
                          ),
                        ],
                      );
                    }
                );
              },
              imagePath: imageFile,
            ),
            AuthTextField(
              controller: nameController,
              textInputType: TextInputType.name,
              hintText: 'Full Name',
              validator: Validator.nameValidator,
              icon: Icons.person_outlined,
            ),
            AuthTextField(
              controller: phoneController,
              textInputType: TextInputType.phone,
              hintText: 'Phone',
              validator: Validator.phoneValidator,
              icon: Icons.phone_outlined,
            ),
            AuthTextField(
              controller: emailController,
              textInputType: TextInputType.emailAddress,
              hintText: 'Email',
              validator: Validator.emailValidator,
              icon: Icons.email_outlined,
            ),
            BasicDateField(
              controller: dobController,
            ),
            PassTextField(
              validator: Validator.passwordValidator,
              controller: passwordController,
            ),
            Button(
              title: 'SIGN UP',
              press: () async {
                // close keyboard
                FocusScope.of(context).unfocus();
              // check network availability
                var connectivityResult = await Connectivity().checkConnectivity();
                if(connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi){
                  showSnackBar('No internet connectivity');
                  return;
                }
                createUser();
              },
              color: AppTheme.primaryColor,
            ),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      imageFile = File(pickedFile!.path);
    });
    Navigator.pop(context);
  }

  void createUser() async {

    //show please wait dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => const ProgressDialog(status: 'Registering you...'),
    );

    // sign user up and add user info to firestore
    final User? user = (
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    ).catchError((ex){
      //check error and display message
      Navigator.pop(context);
      FirebaseAuthException thisEx = ex;
      showSnackBar(thisEx.message!);
    })).user;

    // check if user registration is successful
    if(user != null){
      String? image;
      user.updateDisplayName(nameController.text);
      firebase_storage.Reference ref =
      firebase_storage.FirebaseStorage.instance.ref().child('profile_pics/${user.uid}');
      if (imageFile != null) {
        await ref.putFile(imageFile!);
        image = await ref.getDownloadURL();
        user.updatePhotoURL(image);
      }
      // Prepare and saving to customers collection
      FirebaseFirestore.instance.collection('customers').doc(user.uid).set({
        'fullName': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'DOB': dobController.text,
        'userImage': image,
        'fcmToken': await FirebaseMessaging.instance.getToken(),
      });
      //Navigator.of(context).pop();
      //Take the user to the mainPage
      Navigator.pushNamedAndRemoveUntil(context, MainScreen.id, (route) => false);

    }

    //Navigator.of(context).pop();
  }

  void showSnackBar(String title){
    final snackbar = SnackBar(
      content: Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15),),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
