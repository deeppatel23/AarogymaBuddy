import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthcareapp/chatbot.dart';

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
                Container(
                  child: Text(
                    "Hello " + auth.currentUser!.phoneNumber.toString(),
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
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
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Edit Profile'),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => NewsPage()),
              // );
            },
          ),
          ListTile(
            title: Text('Disease Diagnosis'),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => MyReminder()),
              // );
            },
          ),
          ListTile(
            title: Text('Healthcare Bootcamp'),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => MyBot()),
              // );
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
            title: Text('Nearby PHCs'),
            onTap: () {},
          ),
          ListTile(
            title: Text('Appointments'),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => ML_Model()),
              // );
            },
          ),
          ListTile(
            title: Text('About App'),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => OurTeam()),
              // );
            },
          )
        ],
      ),
    );
  }
}
