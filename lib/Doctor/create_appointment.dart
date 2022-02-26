import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/services.dart';
import 'package:healthcareapp/Doctor/doctor_home.dart';
import 'package:healthcareapp/global.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../homepage.dart';

class CreateAppointment extends StatefulWidget {
  @override
  _CreateAppointmentState createState() => _CreateAppointmentState();
}

class _CreateAppointmentState extends State<CreateAppointment> {
  TextEditingController date = TextEditingController();
  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();
  TextEditingController totalSeats = TextEditingController();

  String name = "";
  String email = "";
  String mobile = "";
  String address = "";
  String speciality = "";
  String experience = "";
  String fee = "";
  String image = "";
  bool validSlot = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentDoctorInfo();
    validSlot = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Appointment'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DateTimePicker(
                type: DateTimePickerType.date,
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
                dateLabelText: 'Appointment Date',
                controller: date,
                onChanged: (val) => setState(() {
                  validSlot = true;
                }),
                validator: (val) {
                  print(val);
                  return null;
                },
                onSaved: (val) => print(val),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DateTimePicker(
                type: DateTimePickerType.time,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                timeLabelText: 'Start Time',
                controller: startTime,
                onChanged: (val) => setState(() {
                  validSlot = true;
                }),
                validator: (val) {
                  print(val);
                  return null;
                },
                onSaved: (val) => print(val),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DateTimePicker(
                type: DateTimePickerType.time,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                timeLabelText: 'End Time',
                controller: endTime,
                onChanged: (val) => setState(() {
                  validSlot = true;
                }),
                validator: (val) {
                  print(val);
                  return null;
                },
                onSaved: (val) => print(val),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: totalSeats,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                decoration: InputDecoration(
                  hintText: 'Total Seats',
                  fillColor: Colors.grey.shade100,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'You must enter total seats';
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  child: Text('Create Appointment'),
                  onPressed: () {
                    validateSlot(date.text, startTime.text, endTime.text);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void getCurrentDoctorInfo() async {
    final uid = currentUid;
    print(currentUid);
    final doc =
        await FirebaseFirestore.instance.collection('doctor').doc(uid).get();
    name = doc['name'];
    email = doc['email'];
    mobile = doc['mobile'];
    address = doc['address'];
    speciality = doc['speciality'];
    experience = doc['experience'];
    fee = doc['fee'];
    image = doc['image'];
  }

  void validateSlot(String date, String sTime, String eTime) async {
    await FirebaseFirestore.instance
        .collection('appointments')
        .where('doctorId', isEqualTo: currentUid)
        .get()
        .then((value) => {
              value.docs.forEach((element) => {
                    if (element.data()['date'] == date &&
                        element
                                .data()['startTime']
                                .toString()
                                .compareTo(eTime) <=
                            0 &&
                        element.data()['endTime'].toString().compareTo(sTime) >=
                            0)
                      {
                        print('Slot already booked'),
                        Fluttertoast.showToast(
                            msg: "You already have appointment in this slot",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0),
                        setState(() {
                          validSlot = false;
                        })
                      }
                  }),
              if (validSlot)
                {
                  createAppointment(),
                }
            });
  }

  void createAppointment() async {
    getCurrentDoctorInfo();
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    _firestore.collection('appointments').doc().set({
      'date': date.text,
      'startTime': startTime.text,
      'endTime': endTime.text,
      'totalSeats': int.parse(totalSeats.text),
      'totalBooking': 0,
      'doctorId': currentUid,
      'doctorName': name,
      'doctorEmail': email,
      'doctorMobile': mobile,
      'doctorAddress': address,
      'doctorSpeciality': speciality,
      'doctorExperience': experience,
      'doctorFee': fee,
    }).then(
      (value) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => doctorHome()),
      ),
    );
  }
}
