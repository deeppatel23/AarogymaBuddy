import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthcareapp/Diagnosis/skin_prediction.dart';
import 'package:healthcareapp/Doctor/create_appointment.dart';
import 'package:healthcareapp/Doctor/view_appointment.dart';
import 'package:healthcareapp/Login/register_user.dart';
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
      builder: (BuildContext context) => const Login(),
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
          setState(() {});
        },
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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
                                "What is your schedule for\ncoming days?",
                                // style: kTitleStyle,
                              ),
                              Spacer(),
                              RaisedButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CreateAppointment()),
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
                                      "Schedule your Slots",
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
                        "images/doctor11.png",
                        fit: BoxFit.contain,
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
                                "View your upcoming\nappointments..",
                                // style: kTitleStyle,
                              ),
                              Spacer(),
                              RaisedButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ViewAppointment()),
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
                                      "View Appointments",
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
    );
  }
}
