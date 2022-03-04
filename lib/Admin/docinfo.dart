import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthcareapp/global.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthcareapp/homepage.dart';
import 'package:healthcareapp/Admin/admin_home.dart';

class DocInfo extends StatefulWidget {
  @override
  // String organName = "";
  // List<String> symptoms = [];
  // Map<String, int> priorityMap = {};
  // GeneralBookAppointment(
  // this.organName, this.symptoms, this.priorityMap
  // );
  _DocInfoState createState() => _DocInfoState();
// this.organName, this.symptoms, this.priorityMap

}

String email = "";
String experience = "";
String fee = "";
String speciality = "";
String image = "";
// int appointmentRemainingSeats = 0;

String name = "";
String mobile = "";
String address = "";

class _DocInfoState extends State<DocInfo> {
  // String _organName = "";
  // List<String> _symptoms = [];
  // Map<String, int> _priorityMap = {};

  // _GeneralBookAppointmentState(String _organ, List<String> s, Map<String, int> mp) {
  // _organName = _organ;
  // _symptoms = s;
  // _priorityMap = mp;
  // print("Organ found:" + _organName);
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getCurrentUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Doctor Info'),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('doctor')
                      // .where('doctorSpeciality', isEqualTo: _organName) huehuehue
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
                        name = document['name'].toString();
                        mobile = document['mobile'].toString();
                        address = document['address'].toString();
                        email = document['email'].toString();
                        experience = document['experience'].toString();
                        fee = document['fee'].toString();
                        // appointmentRemainingSeats =
                        //     document['totalSeats'] - document['totalBooking'];
                        speciality = document['speciality'];
                        // image = document['image'];

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
                                  child: Text("\n Doctor: " +
                                      name +
                                      "\n Speciality : " +
                                      speciality +
                                      "\n Contact No. : " +
                                      mobile +
                                      "\n Email Address : " +
                                      email +
                                      "\n Address : " +
                                      address +
                                      "\n Experience (in years) : " +
                                      experience +
                                      "\n Fees : " +
                                      fee +
                                      '\n'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Do you want to delete this doctor'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  // FirebaseFirestore.instance
                                                  //     .collection("doctor")
                                                  //     .doc("document.id")
                                                  //     .delete();
                                                  DocumentReference
                                                      documentReference =
                                                      FirebaseFirestore.instance
                                                          .collection("doctor")
                                                          .doc(document.id);
                                                  documentReference.delete();

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
                                  child: const Text("Delete"),
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
                          builder: (context) => adminHome(),
                        ),
                      )
                    },
                child: Text("Home"))
          ],
        ));
  }

  // void getCurrentUserInfo() async {
  //   final uid = currentUid;
  //   final doc =
  //       await FirebaseFirestore.instance.collection('users').doc(uid).get();
  //   name = doc['firstName'];
  //   mobile = doc['mobile'];
  //   address = doc['address'];
  // }

  // void Booking(String appId, String docName, String docSpeciality,
  //     String appDate, String appStime, String appEtime) async {
  //   getCurrentUserInfo();
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('appointments')
  //         .doc(appId)
  //         .collection('bookings')
  //         .doc(currentUid)
  //         .set({
  //       'patientName': name,
  //       'patientMobile': mobile,
  //       'patientAddress': address,
  //       'patientId': currentUid,
  //       'doctorName': docName,
  //       'appointmentId': appId,
  //       // 'selectedOrgan': _organName,
  //       // 'selectedSymptoms': _symptoms.toString(),
  //       // 'predictedResults': _priorityMap.toString(),
  //     }).then((value) {
  //       incrementBookedSears(appId);
  //       addBookingToUser(
  //           appId, docName, docSpeciality, appDate, appStime, appEtime);
  //       Fluttertoast.showToast(
  //           msg: "Appointment Booked Successfully",
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.CENTER,
  //           timeInSecForIosWeb: 1,
  //           backgroundColor: Colors.green,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //       Navigator.pushReplacement(
  //           context, MaterialPageRoute(builder: (context) => HomePage()));
  //     });
  //   } catch (e) {
  //     print(e);
  //     Fluttertoast.showToast(
  //         msg: "Error in Booking",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //   }
  // }

//   void incrementBookedSears(String appId) async {
//     int bookedSeats = 0;
//     await FirebaseFirestore.instance
//         .collection('appointments')
//         .doc(appId)
//         .collection('bookings')
//         .get()
//         .then((value) {
//       bookedSeats = value.docs.length;
//     });
//     await FirebaseFirestore.instance
//         .collection('appointments')
//         .doc(appId)
//         .update({
//       'totalBooking': bookedSeats,
//     });
//   }
//
//   void addBookingToUser(String appId, String docName, String docSpeciality,
//       String appDate, String appStime, String appEtime) async {
//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(currentUid)
//         .collection('bookings')
//         .doc(appId)
//         .set({
//       'doctorName': docName,
//       'doctorSpeciality': docSpeciality,
//       'date': appDate,
//       'appointmentId': appId,
//       'startTime': appStime,
//       'endTime': appEtime,
//       // 'selectedOrgan': _organName,
//       // 'selectedSymptoms': _symptoms.toString(),
//       // 'predictedResults': _priorityMap.toString(),
//     });
//   }
// }
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
}
//
// onTap: () =>
// Firestore.instance.collection("doctor").document("document.id").delete();
// .collection("messages").document(snapshot.data.documents[index]["id"])
// .delete();
