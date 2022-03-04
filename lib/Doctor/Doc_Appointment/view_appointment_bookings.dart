import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/services.dart';
import 'package:healthcareapp/global.dart';

import '../../homepage.dart';

class ViewAppointmentBookings extends StatefulWidget {
  @override
  String appointmentId = "";

  ViewAppointmentBookings(this.appointmentId);

  _ViewAppointmentBookingsState createState() =>
      _ViewAppointmentBookingsState(this.appointmentId);
}

class _ViewAppointmentBookingsState extends State<ViewAppointmentBookings> {
  String patientName = "";
  String patientMobile = "";
  String patientAddress = "";
  String selectedOrgan = "";
  String selectedSymptoms = "";
  String predictedResults = "";
  String _appointmentId = "";

  _ViewAppointmentBookingsState(String appointmentId) {
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
                .collection('appointments')
                .doc(_appointmentId)
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
                  patientName = document['patientName'].toString();
                  patientMobile = document['patientMobile'].toString();
                  patientAddress = document['patientAddress'].toString();
                  selectedOrgan = document['selectedOrgan'].toString();
                  selectedSymptoms = document['selectedSymptoms'];
                  predictedResults = document['predictedResults'];

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
                                "\n Mobile : " +
                                patientMobile +
                                "\n Address : " +
                                patientAddress +
                                "\n Selected Organ : " +
                                selectedOrgan.toString() +
                                "\n Selected Symptoms : " +
                                selectedSymptoms.toString() +
                                '\n' +
                                " Predicted Results : " +
                                predictedResults.toString() +
                                '\n'),
                          ),
                        ])),
                  );
                }).toList(),
              );
            }));
  }
}
