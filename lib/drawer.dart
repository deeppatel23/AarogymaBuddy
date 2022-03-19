import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthcareapp/Chatbot/chatbot.dart';
import 'package:healthcareapp/Diagnosis/select_organ.dart';
import 'package:healthcareapp/Login/view_profile.dart';
import 'package:healthcareapp/global.dart';
import 'package:maps_launcher/maps_launcher.dart';

import 'Appointment/my_appointment.dart';
import 'Healthcamp/healthcamp_registration.dart';
import 'Healthcamp/my_registrations.dart';
import 'about.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CircleAvatar(
                    radius: 45,
                    backgroundImage: AssetImage('images/patient.png'),
                    backgroundColor: Colors.white,
                  ),
                ),
                Container(
                  child: Text(
                    "Hello " + patientFirstName,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  decoration: BoxDecoration(
                    color: globalBackgroundColor,
                  ),
                  //     child: Image.asset(
                  //   "assets/SkinShine with text.png",
                  //   width: 137,
                  //   height: 137,
                  // )
                )
              ],
            ),
            decoration: BoxDecoration(
              color: globalBackgroundColor,
            ),
          ),
          ListTile(
            title: Text('View Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewProfile()),
              );
            },
          ),
          ListTile(
            title: Text('Disease Diagnosis'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SelectOrgan()),
              );
            },
          ),
          ListTile(
            title: Text('Healthcare Bootcamp'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyHealthcampRegistrations()),
              );
            },
          ),
          ListTile(
            title: Text('Chatbot'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Chatbot()),
              );
            },
          ),
          ListTile(
            title: Text('Hospitals near me'),
            onTap: () => MapsLauncher.launchQuery('Hospitals near me'),
          ),
          ListTile(
            title: Text('Appointments'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyAppointment()),
              );
            },
          ),
          ListTile(
            title: Text('About App'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutApp()),
              );
            },
          )
        ],
      ),
    );
  }
}
