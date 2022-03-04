import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/services.dart';
import 'package:healthcareapp/Doctor/Doc_Appointment/view_appointment_bookings.dart';
import 'package:healthcareapp/global.dart';

import '../../homepage.dart';

class ViewAppointment extends StatefulWidget {
  @override
  _ViewAppointmentState createState() => _ViewAppointmentState();
}

class _ViewAppointmentState extends State<ViewAppointment> {
  String appointmantDate = "";
  String appointmantStartTime = "";
  String appointmantEndTime = "";
  int appointmantTotalSeats = 0;
  int appointmantTotalBooking = 0;

  // TextEditingController date = TextEditingController();
  // TextEditingController startTime = TextEditingController();
  // TextEditingController endTime = TextEditingController();
  // TextEditingController totalSeats = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('View Appointment'),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('appointments')
                .where('doctorId', isEqualTo: currentUid)
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
                  appointmantDate = document['date'].toString();
                  appointmantStartTime = document['startTime'].toString();
                  appointmantEndTime = document['endTime'].toString();
                  appointmantTotalSeats = document['totalSeats'];
                  appointmantTotalBooking = document['totalBooking'];

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
                            child: Text("\nDate : " +
                                appointmantDate +
                                '\n' +
                                "\n Start Time : " +
                                appointmantStartTime +
                                "\n End Time : " +
                                appointmantEndTime +
                                "\n Total Seats : " +
                                appointmantTotalSeats.toString() +
                                '\n' +
                                " Total Booked : " +
                                appointmantTotalBooking.toString() +
                                '\n'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ViewAppointmentBookings(document.id))),
                            child: const Text('View Bookings'),
                          ),
                        ])),
                  );
                }).toList(),
              );
            }));
  }
}
