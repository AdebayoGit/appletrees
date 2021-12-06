import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:longthroat_customer/components/auth_components.dart';
import 'package:longthroat_customer/components/progress_dialog.dart';
import 'package:longthroat_customer/utilities/app_theme.dart';
import 'package:longthroat_customer/utilities/global_variables.dart';

class Ratings extends StatefulWidget {
  const Ratings({Key? key}) : super(key: key);

  static const String id = 'rating';

  @override
  State<Ratings> createState() => _RatingsState();
}

class _RatingsState extends State<Ratings> {
  final TextEditingController reviewController = TextEditingController();

  String rating = 'neutral';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: RichText(
          text: TextSpan(
            style: Theme.of(context)
                .textTheme
                .headline6!
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'How was your experience ?',
              style: GoogleFonts.lato(
                textStyle: Theme.of(context).textTheme.headline3!.copyWith(
                    fontWeight: FontWeight.w900, color: AppTheme.nearlyBlack),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.02),
              child: Center(
                child: Text(
                  'We are always looking to improve...',
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: AppTheme.kTextLightColor,
                      ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.05),
              child: Text('Rate Us',
                  style: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(color: AppTheme.colorOrange)),
            ),
            RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              itemCount: 5,
              wrapAlignment: WrapAlignment.spaceEvenly,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return const Icon(
                      Icons.sentiment_dissatisfied,
                      color: Colors.redAccent,
                    );
                  case 2:
                    return const Icon(
                      Icons.sentiment_neutral,
                      color: Colors.amber,
                    );
                  case 3:
                    return const Icon(
                      Icons.sentiment_satisfied,
                      color: Colors.lightGreen,
                    );
                  case 4:
                    return const Icon(
                      Icons.sentiment_very_satisfied,
                      color: Colors.green,
                    );
                  default:
                    return const Icon(
                      Icons.sentiment_very_dissatisfied,
                      color: Colors.red,
                    );
                }
              },
              onRatingUpdate: (value) {
                switch (value.toInt()) {
                  case 1:
                    rating = 'very_dissatisfied';
                    break;
                  case 2:
                    rating = 'dissatisfied';
                    break;
                  case 4:
                    rating = 'satisfied';
                    break;
                  case 5:
                    rating = 'very_satisfied';
                    break;
                  default:
                    rating = 'neutral';
                    break;
                }
                print(rating);
              },
            ),
            Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Very Dissatisfied'),
                    Text('Very Satisfied')
                  ],
                )),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: TextFormField(
                controller: reviewController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Review',
                  hintText: 'Let us know what you think...',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.yellow,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppTheme.nearlyBlack,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16.0),
              child: Button(
                title: 'Done',
                color: AppTheme.primaryColor,
                press: () {
                  sendReview();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendReview() {
    //show please wait dialog
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (BuildContext context){
          return const ProgressDialog(status: 'Please wait...');
        }
    );
    FirebaseFirestore.instance.collection('ratings_reviews').add({
      'rating': rating,
      'review': reviewController.text,
      'user': currentUser.uid,
      'date': DateTime.now(),
    });
    reviewController.clear();
    Navigator.of(context).pop();
  }
}

