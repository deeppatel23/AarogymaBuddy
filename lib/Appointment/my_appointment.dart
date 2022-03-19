import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/services.dart';
import 'package:healthcareapp/global.dart';

import '../homepage.dart';

class MyAppointment extends StatefulWidget {
  @override
  _MyAppointmentState createState() => _MyAppointmentState();
}

class _MyAppointmentState extends State<MyAppointment> {
  String appointmentDate = "";
  String appointmentStartTime = "";
  String appointmentEndTime = "";
  String appointmentDoctor = "";
  String appointmentDoctorSpeciality = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Appointment'),
          backgroundColor: globalBackgroundColor,
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(currentUid)
                .collection('bookings')
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
                  appointmentDate = document['date'].toString();
                  appointmentStartTime = document['startTime'].toString();
                  appointmentEndTime = document['endTime'].toString();
                  appointmentDoctor = document['doctorName'].toString();
                  appointmentDoctorSpeciality =
                      document['doctorSpeciality'].toString();

                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromARGB(255, 72, 175, 235),
                                    blurRadius: 5,
                                    offset: Offset(0, 1))
                              ]),
                          child: Column(children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 1.2,
                              height: MediaQuery.of(context).size.height / 6,
                              child: Text("\nDate : " +
                                  appointmentDate +
                                  '\n' +
                                  "\n Start Time : " +
                                  appointmentStartTime +
                                  "\n End Time : " +
                                  appointmentEndTime +
                                  "\n Doctor : " +
                                  appointmentDoctor +
                                  '\n' +
                                  " Doctor Speciality : " +
                                  appointmentDoctorSpeciality +
                                  '\n'),
                            ),
                          ])),
                    ),
                  );
                }).toList(),
              );
            }));
  }
}
