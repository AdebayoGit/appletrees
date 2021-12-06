import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:longthroat_customer/utilities/app_theme.dart';
import 'package:longthroat_customer/views/ratings_review.dart';

class NotificationDialog extends StatelessWidget {
  const NotificationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(4)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              text: TextSpan(
                style: Theme.of(context)
                    .textTheme
                    .headline4!
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  'Dear valued customer, your opinions means a lot to us. If you don\'t mind, tell us what you think of our services.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    textStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: size.width * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        shape: const StadiumBorder(
                            side: BorderSide(color: AppTheme.nearlyBlack)),
                        primary: AppTheme.primaryColor),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Not now',
                      style: TextStyle(
                        color: Colors.red,
                        letterSpacing: 5,
                        wordSpacing: 3,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      backgroundColor: Colors.green,
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, Ratings.id);
                    },
                    child: const Text(
                      'Proceed',
                      style: TextStyle(
                        color: AppTheme.nearlyWhite,
                        letterSpacing: 5,
                        wordSpacing: 3,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
