import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthcareapp/Diagnosis/skin_prediction.dart';
import 'package:healthcareapp/Doctor/Doc_Appointment/create_appointment.dart';
import 'package:healthcareapp/Doctor/Doc_Healthcamp/create_healthcamp.dart';
import 'package:healthcareapp/Doctor/Doc_Appointment/view_appointment.dart';
import 'package:healthcareapp/Doctor/Doc_Healthcamp/view_healthcamp.dart';
import 'package:healthcareapp/Login/register_user.dart';
import 'package:healthcareapp/Login/welcome_screen.dart';
import 'package:healthcareapp/drawer.dart';
import 'package:healthcareapp/Diagnosis/select_organ.dart';

class doctorHome extends StatefulWidget {
  @override
  _doctorHomeState createState() => _doctorHomeState();
}

class _doctorHomeState extends State<doctorHome> {
  String _appName = "Healthcare Doctor";
  String _appDescription = "";
  bool showDes = false;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
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
      // drawer: MyDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                    Widget>[
              SizedBox(height: 30),
              FlatButton(
                height: 150.0,

                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateAppointment()),
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
                                "What is your schedule \nfor coming days?",
                                // style: kTitleStyle,
                              ),
                              Spacer(),
                              Padding(
                                // padding: EdgeInsets.all(16.0),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                // padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0);
                                child: Text('Schedule your slots'),
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
              SizedBox(height: 30),
              FlatButton(
                height: 150.0,

                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateHealthcamp()),
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
                                "What is your schedule\nfor coming days?",

                                // style: kTitleStyle,
                              ),
                              Spacer(),
                              Padding(
                                // padding: EdgeInsets.all(16.0),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                // padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0);
                                child: Text('Create Healthcamp'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Image.asset(
                        // "images/skin.png",
                        "images/a/medicine.gif",

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
                  MaterialPageRoute(builder: (context) => ViewAppointment()),
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
                                "View your upcoming \nappointments...",
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
                        "images/a/syringe.gif",

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
                  MaterialPageRoute(builder: (context) => ViewHealthcamp()),
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
                                "View your upcoming\nHealthcamps...",
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
                        "images/a/medicine2.gif",

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
              // TextButton(
              //   onPressed: () => Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => CreateAppointment()),
              //   ),
              //   child: const Text("Create Appointment"),
              // ),
              // TextButton(
              //   onPressed: () => Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => ViewAppointment()),
              //   ),
              //   child: const Text("View All Appointment"),
              // ),
            ]),
          ),
        ),
      ),
    );
  }
}
