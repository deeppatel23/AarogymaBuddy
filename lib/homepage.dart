import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthcareapp/Appointment/my_appointment.dart';
import 'package:healthcareapp/Appointment/general_book_appointment.dart';
import 'package:healthcareapp/Diagnosis/skin_prediction.dart';
import 'package:healthcareapp/Doctor/Doc_Appointment/view_appointment.dart';
import 'package:healthcareapp/Login/register_user.dart';
import 'package:healthcareapp/Login/welcome_screen.dart';
import 'package:healthcareapp/drawer.dart';
import 'package:healthcareapp/Healthcamp/healthcamp_registration.dart';
import 'package:healthcareapp/Healthcamp/my_registrations.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'Diagnosis/select_organ.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _appName = "Healthcare";
  String _appDescription = "";
  bool showDes = false;
  final FirebaseAuth auth = FirebaseAuth.instance;

  getAppDetails() async {
    await FirebaseFirestore.instance
        .collection('global_details')
        .doc('app')
        .get()
        .then((value) {
      _appName = value.data()!['name'];
      _appDescription = value.data()!['description'];
    });
  }

  @override
  void initState() {
    getAppDetails();
    showDes = false;
    super.initState();
  }

  static Route<void> _myRouteBuilder(BuildContext context, Object? arguments) {
    return MaterialPageRoute<void>(
      builder: (BuildContext context) => const WelcomeScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1FAB89),
        title: Text(_appName == "" ? "App Name" : _appName),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              auth.signOut();
              Navigator.of(context).restorablePushAndRemoveUntil(
                _myRouteBuilder,
                ModalRoute.withName('/'),
              );
            },
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await getAppDetails();
          setState(() {});
        },
        child: SingleChildScrollView(
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 30),
                  FlatButton(
                    height: 150.0,

                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SelectOrgan()),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    color: Colors
                        .transparent, //set this opacity as per your requirement
                    child: Container(
                      width: double.infinity,
                      height: 150.0,
                      margin: EdgeInsets.symmetric(horizontal: 18.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Color(0xFFF38181),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 15.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Do you have symptoms\nof Covid 19?",
                                    // style: kTitleStyle,
                                  ),
                                  Spacer(),
                                  Padding(
                                    // padding: EdgeInsets.all(16.0),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 10.0),
                                    // padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0);
                                    child: Text('Disease Diagnosis'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Image.asset(
                            // "images/skin.png",
                            "images/a/stethoscope.gif",

                            fit: BoxFit.contain,
                            width: 100,
                            height: 100,
                          ),
                          SizedBox(width: 15.0),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  FlatButton(
                    height: 150.0,

                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SkinPrediction()),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    color: Colors
                        .transparent, //set this opacity as per your requirement
                    child: Container(
                      width: double.infinity,
                      height: 150.0,
                      margin: EdgeInsets.symmetric(horizontal: 18.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Color(0xFFFCE38A),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 15.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Do you have skin related\nsymptoms?",
                                    // style: kTitleStyle,
                                  ),
                                  Spacer(),
                                  Padding(
                                    // padding: EdgeInsets.all(16.0),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 1.0),
                                    // padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0);
                                    child: Text('Skin Disease Prediction'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Image.asset(
                            // "images/skin.png",
                            "images/a/microscope.gif",

                            fit: BoxFit.contain,
                            width: 100,
                            height: 100,
                          ),
                          SizedBox(width: 15.0),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  FlatButton(
                    height: 150.0,

                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HealthcampRegistrartion()),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    color: Colors
                        .transparent, //set this opacity as per your requirement
                    child: Container(
                      width: double.infinity,
                      height: 150.0,
                      margin: EdgeInsets.symmetric(horizontal: 18.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Color(0xFFA8D8EA),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 15.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Have you registered for\nHealthcamp yet?",
                                    // style: kTitleStyle,
                                  ),
                                  Spacer(),
                                  Padding(
                                    // padding: EdgeInsets.all(16.0),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 10.0),
                                    // padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0);
                                    child: Text('Register'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Image.asset(
                            // "images/skin.png",
                            "images/a/notebook.gif",

                            fit: BoxFit.contain,
                            width: 100,
                            height: 100,
                          ),
                          SizedBox(width: 15.0),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30), //0xFFAA96DA
                  FlatButton(
                    height: 150.0,

                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyRegistrations()),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    color: Colors
                        .transparent, //set this opacity as per your requirement
                    child: Container(
                      width: double.infinity,
                      height: 150.0,
                      margin: EdgeInsets.symmetric(horizontal: 18.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Color(0xFFAA96DA),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 15.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "View your upcoming \nHealthcamp events",
                                    // style: kTitleStyle,
                                  ),
                                  Spacer(),
                                  Padding(
                                    // padding: EdgeInsets.all(16.0),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 10.0),
                                    // padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0);
                                    child: Text('View'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Image.asset(
                            // "images/skin.png",
                            "images/a/checklist.gif",

                            fit: BoxFit.contain,
                            width: 100,
                            height: 100,
                          ),
                          SizedBox(width: 15.0),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30), //0xFFE0F9B5
                  FlatButton(
                    height: 150.0,

                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GeneralBookAppointment()),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    color: Colors
                        .transparent, //set this opacity as per your requirement
                    child: Container(
                      width: double.infinity,
                      height: 150.0,
                      margin: EdgeInsets.symmetric(horizontal: 18.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Color(0xFFE0F9B5),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 15.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Have you booked your\n Appointment yet?",
                                    // style: kTitleStyle,
                                  ),
                                  Spacer(),
                                  Padding(
                                    // padding: EdgeInsets.all(16.0),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 10.0),
                                    // padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0);
                                    child: Text('Book'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Image.asset(
                            // "images/skin.png",
                            "images/a/consultation.gif",

                            fit: BoxFit.contain,
                            width: 100,
                            height: 100,
                          ),
                          SizedBox(width: 15.0),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30), //0xFFFFD5CD
                  FlatButton(
                    height: 150.0,

                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyAppointment()),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    color: Colors
                        .transparent, //set this opacity as per your requirement
                    child: Container(
                      width: double.infinity,
                      height: 150.0,
                      margin: EdgeInsets.symmetric(horizontal: 18.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Color(0xFFFFD5CD),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 15.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Have you registered for\nHealthcamp yet?",
                                    // style: kTitleStyle,
                                  ),
                                  Spacer(),
                                  Padding(
                                    // padding: EdgeInsets.all(16.0),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 10.0),
                                    // padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0);
                                    child: Text('View'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Image.asset(
                            // "images/skin.png",
                            "images/a/calendar.gif",

                            fit: BoxFit.contain,
                            width: 100,
                            height: 100,
                          ),
                          SizedBox(width: 15.0),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                ]),
          ),
        ),
      ),
    );
  }
}
