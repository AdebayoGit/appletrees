import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:longthroat_customer/components/auth_components.dart';
import 'package:longthroat_customer/models/cart.dart';
import 'package:longthroat_customer/utilities/app_theme.dart';
import 'package:longthroat_customer/utilities/global_variables.dart';
import 'package:provider/provider.dart';

class CheckOutSteps extends StatefulWidget {
  const CheckOutSteps({Key? key}) : super(key: key);

  @override
  State<CheckOutSteps> createState() => _CheckOutStepsState();
}

class _CheckOutStepsState extends State<CheckOutSteps> {
  late int currentStep;
  late String addressInfo;
  late int deliveryFee;

  TextEditingController address = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController notes = TextEditingController();

  _stepState(int step) {
    if (currentStep > step) {
      return StepState.complete;
    } else if (currentStep == step) {
      return StepState.editing;
    } else {
      return StepState.indexed;
    }
  }

  final Map<String, int> priceList = {
    'Agege': 1500,
    'Okoko': 999,
    'Alapere': 1500,
    'Ojo': 499,
    'Seme': 1000,
    'Agidingbi': 1000,
    'Sefu': 500,
    'Aguda': 500,
  };

  //late LatLng? manualLocationData;
  List<String> values = [
    'Agege',
    'Okoko',
    'Alapere',
    'Ojo',
    'Seme',
    'Agidingbi',
    'Sefu',
    'Aguda',
  ];

  String? _value;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentStep = 0;
    FirebaseFirestore.instance
        .collection('orders')
        .where('added_by', isEqualTo: currentUser.uid)
        .where('status', isEqualTo: 'Delivered')
        .orderBy('time')
        .limitToLast(1)
        .get()
        .then((value) {
      phone.text = value.docs.first['phone'] ?? '';
      address.text = value.docs.first['address'] ?? '';
      // Todo add order area to make sure area can be pre-entered for users
      //_value = value.docs.first['orderArea'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final cart = Provider.of<Cart>(context);
    List<Step> steps = [
      Step(
        title: const Text('Delivery Info'),
        content: addressWidget(),
        state: _stepState(0),
        isActive: currentStep == 0,
      ),
      Step(
        title: const Text('Extras'),
        content: notesWidget(),
        state: _stepState(1),
        isActive: currentStep == 1,
      ),
      Step(
        title: const Text('Review'),
        content: reviewWidget(size, cart),
        state: _stepState(2),
        isActive: currentStep == 2,
      ),
    ];
    return Scaffold(
      body: SafeArea(
        child: Stepper(
          type: StepperType.horizontal,
          steps: steps,
          currentStep: currentStep,
          onStepTapped: (step) => setState(() => currentStep = step),
          onStepContinue: () {
            setState(() {
              if (currentStep < steps.length - 1) {
                currentStep += 1;
              }
            });
          },
          onStepCancel: () {
            setState(() {
              if (currentStep > 0) {
                currentStep -= 1;
              } else {
                currentStep = 0;
              }
            });
          },
          controlsBuilder: (BuildContext context,
              {VoidCallback? onStepContinue, VoidCallback? onStepCancel}) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: currentStep == 0
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    if (currentStep != 0)
                      Button(
                        press: onStepCancel!,
                        title: 'BACK',
                        color: Colors.red,
                        textColor: Colors.red,
                      ),
                    Center(
                      child: Button(
                        press: onStepContinue!,
                        title: 'NEXT',
                        color: Colors.green,
                        textColor: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget addressWidget() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: TextFormField(
            controller: phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field cannot be empty';
              }
              return null;
            },
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              suffixIcon: IconButton(
                onPressed: () {
                  phone.clear();
                },
                icon: const Icon(
                  Icons.clear,
                  color: Colors.red,
                ),
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.orange,
                ),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.orange,
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: TextFormField(
            controller: address,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field cannot be empty';
              }
              return null;
            },
            onTap: () async => await _handlePressButton(),
            decoration: InputDecoration(
              labelText: 'Delivery Address',
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.orange,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  address.clear();
                },
                icon: const Icon(
                  Icons.clear,
                  color: Colors.red,
                ),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.orange,
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: DropdownButtonFormField<String>(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field cannot be empty';
              }
              return null;
            },
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Colors.orange,
            ),
            iconSize: 42,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.orange,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.orange,
                ),
              ),
            ),
            isExpanded: true,
            value: _value,
            hint: const FittedBox(
              fit: BoxFit.contain,
              child: Text(
                'Choose your location area',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            //elevation: 5,
            onChanged: (String? value) {
              setState(() {
                _value = value;
                deliveryFee = priceList[value]!;
              });
            },
            items: values.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget notesWidget() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: TextFormField(
        controller: notes,
        maxLines: 5,
        decoration: const InputDecoration(
          labelText: 'Note',
          hintText: 'eg. Drop with security, add extra pepper ...',
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.yellow,
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.yellow,
            ),
          ),
        ),
      ),
    );
  }

  Widget reviewWidget(Size size, Cart cart) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: size.width * 0.01),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: size.width * 0.09),
              child: Column(
                children: [
                  SvgPicture.asset('assets/icons/macdonalds.svg',
                      color: Colors.orange),
                  RichText(
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
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      'thrill your taste buds...',
                      style: GoogleFonts.dancingScript(
                        textStyle:
                            Theme.of(context).textTheme.headline4!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.kTextLightColor,
                                  fontStyle: FontStyle.italic,
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(fontWeight: FontWeight.bold),
                  children: [
                    const TextSpan(
                      text: "Name: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: currentUser.displayName,
                      style: const TextStyle(color: AppTheme.primaryColor),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(fontWeight: FontWeight.bold),
                  children: [
                    const TextSpan(
                      text: "User Id: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: currentUser.uid,
                      style: const TextStyle(color: AppTheme.primaryColor),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(fontWeight: FontWeight.bold),
                  children: [
                    const TextSpan(
                      text: "Phone Number: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: phone.text,
                      style: const TextStyle(color: AppTheme.primaryColor),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(fontWeight: FontWeight.bold),
                  children: [
                    const TextSpan(
                      text: "Address: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: address.text,
                      style: const TextStyle(color: AppTheme.primaryColor),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(fontWeight: FontWeight.bold),
                  children: [
                    const TextSpan(
                      text: "Order Area: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: _value,
                      style: const TextStyle(color: AppTheme.primaryColor),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(fontWeight: FontWeight.bold),
                  children: [
                    const TextSpan(
                      text: "Notes: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: notes.text,
                      style: const TextStyle(color: AppTheme.primaryColor),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(fontWeight: FontWeight.bold),
                  children: [
                    const TextSpan(
                      text: "Order Summary: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: orderSummary(cart),
                      style: const TextStyle(color: AppTheme.primaryColor),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(fontWeight: FontWeight.bold),
                  children: [
                    const TextSpan(
                      text: "Food Price: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: orderSummary(cart),
                      style: const TextStyle(color: AppTheme.primaryColor),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(fontWeight: FontWeight.bold),
                  children: [
                    const TextSpan(
                      text: "Delivery Fee: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: priceList[_value].toString(),
                      style: const TextStyle(color: AppTheme.primaryColor),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(fontWeight: FontWeight.bold),
                  children: const [
                    TextSpan(
                      text: "Total: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '5000',
                      style: TextStyle(color: AppTheme.primaryColor),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  String orderSummary(Cart cart) {
    if (cart.local > 0 && cart.continental > 0) {
      return '${cart.local} local(s) & ${cart.continental} continental(s)';
    } else if (cart.local > 0 && cart.continental == 0) {
      return '${cart.local} local(s)';
    } else if (cart.local == 0 && cart.continental > 0) {
      return '${cart.continental} continental(s)';
    } else {
      return '';
    }
  }

  /*stepContinue() {
    if (currentStep == 1) {
      if (_formKey.currentState!.validate() && _value != null) {
        setState(() {
          currentStep = 2;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Center(child: Text('Please fill out all fields')),));
      }
    } else{
      setState(() {
        currentStep += 1;
      });
    }
  }*/

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(response.errorMessage!)));
  }

  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: 'AIzaSyCPZFdwGmyCOptjeqqFrhysuvQqrsieEAY',
      location: Location(lat: 6.5244, lng: 3.3792),
      onError: onError,
      logo: const SizedBox(),
      mode: Mode.overlay,
      types: [],
      strictbounds: false,
      language: "en",
      components: [Component(Component.country, "ng")],
    );

    await displayPrediction(p);
  }

  Future displayPrediction(Prediction? p) async {
    if (p != null) {
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: 'AIzaSyCPZFdwGmyCOptjeqqFrhysuvQqrsieEAY',
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId!);
      addressInfo = detail.result.formattedAddress!;
      setState(() {
        address.text = addressInfo;
      });
      //return LatLng(detail.result.geometry!.location.lat, detail.result.geometry!.location.lng);
    }
  }
}
