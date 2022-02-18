import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthcareapp/global.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthcareapp/homepage.dart';

class BookAppointment extends StatefulWidget {
  @override
  String organName = "";
  BookAppointment(this.organName);
  _BookAppointmentState createState() => _BookAppointmentState(this.organName);
}

String appointmentDate = "";
String appointmentStartTime = "";
String appointmentEndTime = "";
String appointmentDoctor = "";
String appointmentDoctorSpeciality = "";
int appointmentRemainingSeats = 0;

String name = "";
String mobile = "";
String address = "";

class _BookAppointmentState extends State<BookAppointment> {
  String _organName = "";

  _BookAppointmentState(String _organ) {
    _organName = _organ;
    print(_organName);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Book Appointment'),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('appointments')
                      .where('doctorSpeciality', isEqualTo: _organName)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
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
                        appointmentRemainingSeats =
                            document['totalSeats'] - document['totalBooking'];
                        appointmentDoctor = document['doctorName'];
                        appointmentDoctorSpeciality =
                            document['doctorSpeciality'];

                        return Center(
                          child: Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blue[100]),
                              child: Column(children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  height:
                                      MediaQuery.of(context).size.height / 6,
                                  child: Text("\nDate : " +
                                      appointmentDate +
                                      '\n' +
                                      "\n Start Time : " +
                                      appointmentStartTime +
                                      "\n End Time : " +
                                      appointmentEndTime +
                                      "\n Total Seats : " +
                                      appointmentRemainingSeats.toString() +
                                      '\n'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Booking(
                                        document.id,
                                        document['doctorName'],
                                        document['doctorSpeciality'],
                                        document['date'].toString(),
                                        document['startTime'].toString(),
                                        document['endTime'].toString());
                                  },
                                  child: const Text("Book Appointment"),
                                )
                              ])),
                        );
                      }).toList(),
                    );
                  }),
            ),
            ElevatedButton(
                onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      )
                    },
                child: Text("Home"))
          ],
        ));
  }

  void getCurrentUserInfo() async {
    final uid = currentUid;
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    name = doc['firstName'];
    mobile = doc['mobile'];
    address = doc['address'];
  }

  void Booking(String appId, String docName, String docSpeciality,
      String appDate, String appStime, String appEtime) async {
    getCurrentUserInfo();
    await FirebaseFirestore.instance
        .collection('appointments')
        .doc(appId)
        .collection('bookings')
        .doc(currentUid)
        .set({
          'name': name,
          'mobile': mobile,
          'address': address,
          'userId': currentUid,
        })
        .then((value) => FirebaseFirestore.instance
                .collection('appointments')
                .doc(appId)
                .update({
              'totalBooking': FieldValue.increment(1),
            }))
        .then((value) => FirebaseFirestore.instance
                .collection('users')
                .doc(currentUid)
                .collection('bookings')
                .doc(appId)
                .set({
              'doctorName': docName,
              'doctorSpeciality': docSpeciality,
              'date': appDate,
              'appointmentId': appId,
              'startTime': appStime,
              'endTime': appEtime,
            }));
  }
} 
    // catch (e) {
    //   print(e.toString());
    // }

    

    // try {
    //   await FirebaseFirestore.instance
    //       .collection('users')
    //       .doc(currentUid)
    //       .collection('bookings')
    //       .doc(appId)
    //       .set({
    //     'doctorName': docName,
    //     'doctorSpeciality': docSpeciality,
    //     'date': appDate,
    //     'appointmentId': appId,
    //     'startTime': appStime,
    //     'endTime': appEtime,
    //   });
    // } catch (e) {
    //   Fluttertoast.showToast(
    //       msg: "Appointment booked earlier",
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.CENTER,
    //       timeInSecForIosWeb: 1,
    //       backgroundColor: Colors.red,
    //       textColor: Colors.white,
    //       fontSize: 16.0);
    // }
  

