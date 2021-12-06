import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:longthroat_customer/components/auth_components.dart';
import 'package:longthroat_customer/components/progress_dialog.dart';
import 'package:longthroat_customer/utilities/app_theme.dart';
import 'package:longthroat_customer/utilities/clipping_class.dart';
import 'package:longthroat_customer/utilities/minor_helpers.dart';
import 'package:longthroat_customer/utilities/validator.dart';
import 'package:longthroat_customer/views/sign_up.dart';

import 'main_page.dart';

class SignIn extends StatefulWidget {
  static const String id = 'signIn';
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                ClipPath(
                  clipper: ClippingClass(),
                  child: ShaderMask(
                    shaderCallback: (rect) => const LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [Colors.black, Colors.transparent],
                    ).createShader(rect),
                    blendMode: BlendMode.darken,
                    child: Container(
                      height: size.height * 0.5,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/burger.png'),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.black54, BlendMode.darken),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                  child: Column(
                    children: [
                      Text(
                        'Sign In',
                        style: GoogleFonts.lato(
                          textStyle:
                              Theme.of(context).textTheme.headline3!.copyWith(
                                    fontWeight: FontWeight.w900,
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 1
                                      ..color = AppTheme.primaryColor,
                                  ),
                        ),
                      ),
                      AuthTextField(
                        controller: emailController,
                        textInputType: TextInputType.emailAddress,
                        hintText: 'Email',
                        validator: Validator.emailValidator,
                        icon: Icons.email_outlined,
                      ),
                      PassTextField(
                        validator: Validator.passwordValidator,
                        controller: passwordController,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot Password ?',
                          ),
                        ),
                      ),
                      Button(
                        title: 'SIGN IN',
                        press: () {
                          signIn();
                        },
                        color: AppTheme.primaryColor,
                      ),
                      AlreadyHaveAnAccountCheck(
                        press: () {
                          Navigator.of(context).push(
                            createRoute(
                              const SignUp(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: size.height * 0.25,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context)
                            .textTheme
                            .headline3!
                            .copyWith(fontWeight: FontWeight.bold),
                        children: const [
                          TextSpan(
                            text: "Apple",
                            style: TextStyle(color: AppTheme.secondaryColor),
                          ),
                          TextSpan(
                            text: "Trees",
                            style: TextStyle(color: AppTheme.primaryColor),
                          ),
                          TextSpan(
                            text: ".",
                            style: TextStyle(color: Colors.orange),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TyperAnimatedText(
                            'thrill your taste buds...',
                            textStyle: GoogleFonts.dancingScript(
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.kTextLightColor,
                                    fontStyle: FontStyle.italic,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void signIn() async {

    //show please wait dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => const ProgressDialog(status: 'Please wait...',),
    );

    final User? user = (
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    ).catchError((ex){
      //check error and display message
      Navigator.pop(context);
      FirebaseAuthException thisEx = ex;
      MinorHelper.showSnackBar(thisEx.message!, context);

    })).user;

    if(user != null){
      // verify login
      DocumentReference userRef = FirebaseFirestore.instance.collection('customers').doc(user.uid);
      userRef.get().then((DocumentSnapshot snapshot) async {
        if(snapshot.exists){
          userRef.update({
            'fcmToken': await FirebaseMessaging.instance.getToken(),
          });
          Navigator.pushNamedAndRemoveUntil(context, MainScreen.id, (route) => false);
        }
      });
    }
  }
}
