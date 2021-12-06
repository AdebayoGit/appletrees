import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:longthroat_customer/utilities/app_theme.dart';
import 'package:intl/intl.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppTheme.primaryColor),
        ),
      ),
      child: child,
    );
  }
}

class PassTextField extends StatefulWidget {
  final String? Function(String?)? validator;
  final TextEditingController controller;
  const PassTextField({
    Key? key,
    required this.validator,
    required this.controller,
  }) : super(key: key);

  @override
  _PassTextFieldState createState() => _PassTextFieldState();
}

class _PassTextFieldState extends State<PassTextField> {
  bool _obscureText = true;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
        child: TextFormField(
            controller: widget.controller,
            obscureText: _obscureText,
            validator: widget.validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            cursorColor: AppTheme.primaryColor,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              icon: const Icon(
                Icons.lock_outlined,
                color: AppTheme.primaryColor,
              ),
              hintText: "Password",
              suffixIcon: IconButton(
                icon: Icon(_obscureText
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined),
                color: AppTheme.primaryColor,
                onPressed: _toggle,
              ),
              border: InputBorder.none,
            )));
  }
}

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType textInputType;
  final String hintText;
  final String? Function(String?)? validator;
  final IconData icon;

  const AuthTextField({
    Key? key,
    required this.controller,
    required this.textInputType,
    required this.hintText,
    required this.validator,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
        child: TextFormField(
            controller: controller,
            validator: validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            cursorColor: AppTheme.primaryColor,
            keyboardType: textInputType,
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(
                icon,
                color: AppTheme.primaryColor,
              ),
              hintText: hintText,
            )));
  }
}

class Button extends StatelessWidget {
  final String title;
  final VoidCallback press;
  final Color color, textColor;
  const Button({
    Key? key,
    required this.title,
    required this.press,
    required this.color,
    this.textColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0),
      //width: size.width * 0.8,
      decoration: BoxDecoration(
        border: Border.all(
          color: color,
        ),
        borderRadius: BorderRadius.circular(29),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        ),
        onPressed: press,
        child: Text(
          title,
          style: TextStyle(
              color: textColor,
              letterSpacing: 5,
              wordSpacing: 3,
              fontSize: 15,
              fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final VoidCallback press;
  const AlreadyHaveAnAccountCheck({
    Key? key,
    this.login = true,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            login ? "Don’t have an Account ? " : "Already have an Account ? ",
            style: const TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 15,
            ),
          ),
          TextButton(
            onPressed: press,
            child: Text(
              login ? "Sign Up" : "Sign In",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImageWidget extends StatelessWidget {
  final File? imagePath;
  final VoidCallback onClicked;

  const ImageWidget({
    Key? key,
    this.imagePath,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(color),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    final ImageProvider image;
    if (imagePath == null){
      image = const NetworkImage('https://bit.ly/3CQb4Hn');
    } else {
      image = FileImage(imagePath!);
    }

    return ClipOval(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppTheme.primaryColor,
          ),
          shape: BoxShape.circle,
        ),
        child: Material(
          color: Colors.transparent,
          child: Ink.image(
            image: image,
            fit: BoxFit.cover,
            width: 100,
            height: 100,
            child: InkWell(onTap: onClicked),
          ),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        child: buildCircle(
          color: color,
          all: 8,
          child: const Icon(
            Icons.add_a_photo_outlined,
            color: Colors.white,
            size: 12,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    double all = 0,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          child: child,
          color: color,
        ),
      );
}

class BasicDateField extends StatelessWidget {
  final format = DateFormat("yyyy-MM-dd");
  final TextEditingController controller;

  BasicDateField({required this.controller, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: DateTimeField(
        controller: controller,
        format: format,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: const Icon(
            Icons.event_outlined,
            color: AppTheme.primaryColor,
          ),
          hintText: "DOB",
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.info_outlined,
              color: AppTheme.primaryColor,
            ),
            onPressed: () {
              final snackBar = SnackBar(
                content: const Text(
                    'We take you date of birth to offer you personalized '
                        'discounts on your special day.',
                ),
                action: SnackBarAction(
                  label: 'Dismiss',
                  onPressed: () {
                    // Some code to undo the change.
                  },
                ),
              );

              // Find the ScaffoldMessenger in the widget tree
              // and use it to show a SnackBar.
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
        ),
        onShowPicker: (context, currentValue) {
          return showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime.now(),
          );
        },
      ),
    );
  }
}

Route createRoute(page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.easeIn;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
