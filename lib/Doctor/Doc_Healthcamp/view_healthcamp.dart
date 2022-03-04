import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthcareapp/Doctor/Doc_Healthcamp/view_healthcamp_bookings.dart';
import 'package:healthcareapp/global.dart';

import '../../homepage.dart';

class ViewHealthcamp extends StatefulWidget {
  @override
  _ViewHealthcampState createState() => _ViewHealthcampState();
}

class _ViewHealthcampState extends State<ViewHealthcamp> {
  String campDate = "";
  String campAddress = "";
  String campDescription = "";
  String campStartTime = "";
  String campEndTime = "";
  int campTotalSeats = 0;
  int campTotalBooking = 0;

  // TextEditingController date = TextEditingController();
  // TextEditingController startTime = TextEditingController();
  // TextEditingController endTime = TextEditingController();
  // TextEditingController totalSeats = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('View Healthcamp'),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('healthcamp')
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
                  campDate = document['date'].toString();
                  campStartTime = document['startTime'].toString();
                  campEndTime = document['endTime'].toString();
                  campTotalSeats = document['totalSeats'];
                  campAddress = document['campAddress'];
                  campDescription = document['description'];
                  campTotalBooking = document['totalBooking'];

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
                            height: MediaQuery.of(context).size.height / 4,
                            child: Text("\n Date : " +
                                campDate +
                                "\n Start Time : " +
                                campStartTime +
                                "\n End Time : " +
                                campEndTime +
                                "\n Total Seats : " +
                                campTotalSeats.toString() +
                                '\n' +
                                " Total Booked : " +
                                campTotalBooking.toString() +
                                "\n Address : " +
                                campAddress +
                                "\n Description : " +
                                campDescription +
                                '\n'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ViewHealthcampBookings(document.id))),
                            child: const Text('View Bookings'),
                          ),
                        ])),
                  );
                }).toList(),
              );
            }));
  }
}
