import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthcareapp/Diagnosis/skin_prediction.dart';
import 'package:healthcareapp/Login/register_user.dart';
import 'package:healthcareapp/Login/welcome_screen.dart';
import 'package:healthcareapp/drawer.dart';
import 'package:healthcareapp/Admin/docinfo.dart';
import 'package:healthcareapp/Admin/patientinfo.dart';

import 'package:healthcareapp/Diagnosis/select_organ.dart';

class adminHome extends StatefulWidget {
  @override
  _adminHomeState createState() => _adminHomeState();
}

class _adminHomeState extends State<adminHome> {
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
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                    onPressed: () {
                      setState(() {
                        getAppDetails();
                        showDes = !showDes;
                      });
                    },
                    child: const Text("ADMIN HOME PAGE")),
                showDes == true
                    ? Text(_appDescription == ""
                        ? "App Description"
                        : _appDescription)
                    : Container(),
                // TextButton(
                //   onPressed: () => Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (context) => const SelectOrgan()),
                //   ),
                //   child: const Text("Select Organ"),
                // ),
                // TextButton(
                //   onPressed: () => Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (context) => SkinPrediction()),
                //   ),
                //   child: const Text("Skin Disease Prediction"),
                // ),
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  height: 150.0,
                  margin: EdgeInsets.symmetric(horizontal: 18.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Color(0xFFDAF2FC),
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
                                "Have you booked your\nappointment yet?",
                                // style: kTitleStyle,
                              ),
                              Spacer(),
                              RaisedButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DocInfo()),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                color: Color(0xFF40BEEE),
                                elevation: 2.0,
                                child: SizedBox(
                                  width: 150.0,
                                  height: 50.0,
                                  child: Center(
                                    child: Text(
                                      "Doctor info",
                                      // style: ,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Image.asset(
                        "images/calendar.png",
                        fit: BoxFit.contain,
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(width: 15.0),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  height: 150.0,
                  margin: EdgeInsets.symmetric(horizontal: 18.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Color(0xFFDAF2FC),
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
                                "Have you booked your\nappointment yet?",
                                // style: kTitleStyle,
                              ),
                              Spacer(),
                              RaisedButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PatientInfo()),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                color: Color(0xFF40BEEE),
                                elevation: 2.0,
                                child: SizedBox(
                                  width: 150.0,
                                  height: 50.0,
                                  child: Center(
                                    child: Text(
                                      "Patient Info",
                                      // style: ,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Image.asset(
                        "images/calendar.png",
                        fit: BoxFit.contain,
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(width: 15.0),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
