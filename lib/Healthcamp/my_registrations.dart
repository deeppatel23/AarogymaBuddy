import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/services.dart';
import 'package:healthcareapp/global.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

import '../homepage.dart';

Future<void> _launchInBrowser(String url) async {
  if (!await launch(
    url,
    forceSafariVC: false,
    forceWebView: false,
    headers: <String, String>{'my_header_key': 'my_header_value'},
  )) {
    throw 'Could not launch $url';
  }
}

class MyRegistrations extends StatefulWidget {
  @override
  _MyRegistrationsState createState() => _MyRegistrationsState();
}

class _MyRegistrationsState extends State<MyRegistrations> {
  Future<void>? _launched;
  String healthcampDate = "";
  String healthcampStartTime = "";
  String healthcampEndTime = "";
  String healthcampDoctor = "";
  String healthcampDoctorSpeciality = "";
  String healthcampAddress = "";
  String healthcampLink = "";
  String healthcampDescription = "";
  bool mode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Registrations'),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(currentUid)
                .collection('registrations')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                children: snapshot.data!.docs.map((document) {
                  healthcampDate = document['date'].toString();
                  healthcampStartTime = document['startTime'].toString();
                  healthcampEndTime = document['endTime'].toString();
                  healthcampDoctor = document['doctorName'].toString();
                  healthcampDescription = document['description'].toString();
                  mode = document['mode'];
                  if (mode) healthcampLink = document['campAddress'].toString();
                  if (!mode)
                    healthcampAddress = document['campAddress'].toString();
                  healthcampDoctorSpeciality =
                      document['doctorSpeciality'].toString();

                  return Center(
                    child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue[100]),
                        child: Column(children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            height: MediaQuery.of(context).size.height / 5,
                            child: Text("\nDate : " +
                                healthcampDate +
                                '\n' +
                                "\n Start Time : " +
                                healthcampStartTime +
                                "\n End Time : " +
                                healthcampEndTime +
                                // "\n Address: " +
                                // healthcampAddress +
                                "\n Description : " +
                                healthcampDescription +
                                "\n Doctor : " +
                                healthcampDoctor +
                                '\n' +
                                " Doctor Speciality : " +
                                healthcampDoctorSpeciality +
                                '\n'),
                          ),
                          if (mode)
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                            "Do u want to join this seminar?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              print(
                                                  "PRESSEDDDDDDDDDDDDDDDDDDDDDDDDDDD");
                                              _launched = _launchInBrowser(
                                                  healthcampLink);
                                              Navigator.pop(context);
                                            },
                                            child: Text('Confirm'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancel'),
                                          )
                                        ],
                                      );
                                    });
                              },
                              child: const Text("Attend Online"),
                            ),
                          if (!mode)
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                            "Do u want to check healthcamp's address? "),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              MapsLauncher.launchQuery(
                                                  healthcampAddress);

                                              Navigator.pop(context);
                                            },
                                            child: Text('Confirm'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancel'),
                                          )
                                        ],
                                      );
                                    });
                              },
                              child: const Text("Location"),
                            ),
                        ])),
                  );
                }).toList(),
              );
            }));
  }
}
