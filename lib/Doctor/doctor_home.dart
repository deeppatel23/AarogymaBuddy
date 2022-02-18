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
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateAppointment()),
                  ),
                  child: const Text("Create Appointment"),
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewAppointment()),
                  ),
                  child: const Text("View All Appointment"),
                ),
              ]),
        ),
      ),
    );
  }
}
