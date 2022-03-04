import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/services.dart';
import 'package:healthcareapp/global.dart';

import '../../homepage.dart';

class ViewHealthcampBookings extends StatefulWidget {
  @override
  String appointmentId = "";

  ViewHealthcampBookings(this.appointmentId);

  _ViewHealthcampBookingsState createState() =>
      _ViewHealthcampBookingsState(this.appointmentId);
}

class _ViewHealthcampBookingsState extends State<ViewHealthcampBookings> {
  String patientName = "";
  String patientMobile = "";
  String patientAddress = "";
  // String selectedOrgan = "";
  // String selectedSymptoms = "";
  // String predictedResults = "";
  String _appointmentId = "";

  _ViewHealthcampBookingsState(String appointmentId) {
    _appointmentId = appointmentId;
    print("Appointment Id: " + _appointmentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Patient's Details"),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('healthcamp')
                .doc(_appointmentId)
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
                  patientName = document['patientName'].toString();
                  patientMobile = document['patientMobile'].toString();
                  patientAddress = document['patientAddress'].toString();
                  // selectedOrgan = document['selectedOrgan'].toString();
                  // selectedSymptoms = document['selectedSymptoms'];
                  // predictedResults = document['predictedResults'];

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
                            height: MediaQuery.of(context).size.height / 6,
                            child: Text("\nPatient Name : " +
                                patientName +
                                '\n' +
                                "\nMobile : " +
                                patientMobile +
                                // "\n Address : " +
                                // patientAddress +
                                // "\n Selected Organ : " +
                                // selectedOrgan.toString() +
                                // "\n Selected Symptoms : " +
                                // selectedSymptoms.toString() +
                                // '\n' +
                                // " Predicted Results : " +
                                // predictedResults.toString() +
                                '\n'),
                          ),
                        ])),
                  );
                }).toList(),
              );
            }));
  }
}
