import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthcareapp/global.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthcareapp/homepage.dart';

class HealthcampRegistrartion extends StatefulWidget {
  @override
  // String organName = "";
  // List<String> symptoms = [];
  // Map<String, int> priorityMap = {};
  // GeneralBookAppointment(
  // this.organName, this.symptoms, this.priorityMap
  // );
  _HealthcampRegistrartionState createState() =>
      _HealthcampRegistrartionState();
// this.organName, this.symptoms, this.priorityMap

}

String healthcampDate = "";
String healthcampStartTime = "";
String healthcampEndTime = "";
String healthcampDoctor = "";
String healthcampDoctorSpeciality = "";
String healthcampAddress = "";
String healthcampDescription = "";
bool mode = true;
int healthcampRemainingSeats = 0;

String name = "";
String mobile = "";
String address = "";

class _HealthcampRegistrartionState extends State<HealthcampRegistrartion> {
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
    getCurrentUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Healthcamp Registration'),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('healthcamp')
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
                        healthcampDate = document['date'].toString();
                        healthcampStartTime = document['startTime'].toString();
                        healthcampEndTime = document['endTime'].toString();
                        healthcampRemainingSeats =
                            document['totalSeats'] - document['totalBooking'];
                        healthcampDoctor = document['doctorName'];
                        healthcampDoctorSpeciality =
                            document['doctorSpeciality'];
                        healthcampAddress = document['campAddress'];
                        healthcampDescription = document['description'];
                        mode = document['mode'];

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
                                      MediaQuery.of(context).size.height / 4,
                                  child: Text("\n Doctor: " +
                                      healthcampDoctor +
                                      "\n Date : " +
                                      healthcampDate +
                                      "\n Start Time : " +
                                      healthcampStartTime +
                                      "\n End Time : " +
                                      healthcampEndTime +
                                      "\n Address : " +
                                      healthcampAddress +
                                      "\n Description : " +
                                      healthcampDescription +
                                      "\n remaining seats : " +
                                      healthcampRemainingSeats.toString() +
                                      // "\n mode: " +
                                      // mode.toString() +
                                      '\n'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Confirm your registration'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Booking(
                                                    document.id,
                                                    document['doctorName'],
                                                    document[
                                                        'doctorSpeciality'],
                                                    document['date'].toString(),
                                                    document['startTime']
                                                        .toString(),
                                                    document['endTime']
                                                        .toString(),
                                                    document['description'],
                                                    document['campAddress'],
                                                    document['mode'],
                                                  );
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
                                  child: const Text("Register"),
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

  void Booking(
      String appId,
      String docName,
      String docSpeciality,
      String appDate,
      String appStime,
      String appEtime,
      String description,
      String campAddress,
      bool mode) async {
    getCurrentUserInfo();
    try {
      await FirebaseFirestore.instance
          .collection('healthcamp')
          .doc(appId)
          .collection('registrations')
          .doc(currentUid)
          .set({
        'patientName': name,
        'patientMobile': mobile,
        'patientAddress': address,
        'patientId': currentUid,
        'doctorName': docName,
        'appointmentId': appId,
        'description': description,
        'campAddress': campAddress,
        'mode': mode,
        // 'selectedOrgan': _organName,
        // 'selectedSymptoms': _symptoms.toString(),
        // 'predictedResults': _priorityMap.toString(),
      }).then((value) {
        incrementBookedSears(appId);
        addBookingToUser(appId, docName, docSpeciality, appDate, appStime,
            appEtime, description, campAddress, mode);
        Fluttertoast.showToast(
            msg: "Registration Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: "Error in Registration",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void incrementBookedSears(String appId) async {
    int bookedSeats = 0;
    await FirebaseFirestore.instance
        .collection('healthcamp')
        .doc(appId)
        .collection('registrations')
        .get()
        .then((value) {
      bookedSeats = value.docs.length;
    });
    await FirebaseFirestore.instance
        .collection('healthcamp')
        .doc(appId)
        .update({
      'totalBooking': bookedSeats,
    });
  }

  void addBookingToUser(
      String appId,
      String docName,
      String docSpeciality,
      String appDate,
      String appStime,
      String appEtime,
      String description,
      String campAddress,
      bool mode) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUid)
        .collection('registrations')
        .doc(appId)
        .set({
      'doctorName': docName,
      'doctorSpeciality': docSpeciality,
      'date': appDate,
      'appointmentId': appId,
      'startTime': appStime,
      'endTime': appEtime,
      'description': description,
      'campAddress': campAddress,
      'mode': mode,

      // 'selectedOrgan': _organName,
      // 'selectedSymptoms': _symptoms.toString(),
      // 'predictedResults': _priorityMap.toString(),
    });
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
