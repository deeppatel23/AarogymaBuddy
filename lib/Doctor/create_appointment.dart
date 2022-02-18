import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/services.dart';
import 'package:healthcareapp/Doctor/doctor_home.dart';

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
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                dateLabelText: 'Appointment Date',
                controller: date,
                onChanged: (val) => print(val),
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
                onChanged: (val) => print(val),
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
                onChanged: (val) => print(val),
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
                    createAppointment();
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void createAppointment() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    User currentUser = await auth.currentUser!;
    print("User id" + currentUser.uid);
    _firestore
        .collection('doctor')
        .doc(currentUser.uid)
        .collection('appointments')
        .doc()
        .set({
      'date': date.text,
      'startTime': startTime.text,
      'endTime': endTime.text,
      'totalSeats': int.parse(totalSeats.text),
      'totalBooking': 0,
    }).then(
      (value) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => doctorHome()),
      ),
    );
  }
}