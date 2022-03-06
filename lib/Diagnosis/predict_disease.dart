import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthcareapp/Appointment/book_appointment.dart';
import 'package:healthcareapp/global.dart';
import 'package:healthcareapp/homepage.dart';

class PredictDisease extends StatefulWidget {
  final List<String> finalSymptoms;
  String organId;
  PredictDisease(this.finalSymptoms, this.organId);
  @override
  _PredictDiseaseState createState() =>
      _PredictDiseaseState(this.finalSymptoms, this.organId);
}

class _PredictDiseaseState extends State<PredictDisease> {
  List<String> selectedSymptomsList = [];
  String _organId = "";
  String _organName = "";
  String _patientName = "";
  String _patientState = "";
  String _patientCity = "";
  double _patientLat = 0;
  double _patientLong = 0;
  Map<String, int> priorityMap = {};
  _PredictDiseaseState(List<String> symptoms, String organ) {
    selectedSymptomsList = symptoms;
    _organId = organ;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrganName();
    getCurrentUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Predict Disease"),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('diagnosis')
                      .doc(_organId)
                      .collection("diseases")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      final allDiseases = snapshot.data!.docs;
                      List<Widget> predictedDiseases = [];
                      for (var disease in allDiseases) {
                        for (var symptom
                            in disease.get("symptoms" + selectedLang)) {
                          if (selectedSymptomsList.contains(symptom)) {
                            priorityMap[disease['disease' + selectedLang]] =
                                priorityMap.containsKey(
                                        disease['disease' + selectedLang])
                                    ? priorityMap[disease[
                                            'disease' + selectedLang]]! +
                                        1
                                    : 1;
                          }
                        }
                      }
                      print(priorityMap);

                      for (var key in priorityMap.keys) {
                        print(priorityMap[key]);
                        if (priorityMap[key]! > 1) {
                          predictedDiseases.add(ListTile(
                              title: Text(
                                "$key",
                                style: const TextStyle(
                                  fontSize: 20.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: priorityMap[key]! > 3
                                  ? const Text(
                                      "High Probability",
                                      style: TextStyle(
                                          fontSize: 17.5,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.redAccent),
                                    )
                                  : const Text(
                                      "Medium Probability",
                                      style: TextStyle(
                                          fontSize: 17.5,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.yellow),
                                    )));
                        } else if (priorityMap[key]! > 0) {
                          predictedDiseases.add(ListTile(
                              title: Text(
                                "$key",
                                style: const TextStyle(
                                  fontSize: 20.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: priorityMap[key]! > 0
                                  ? const Text(
                                      "Low Probability",
                                      style: TextStyle(
                                          fontSize: 17.5,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.lightBlue),
                                    )
                                  : const Text(
                                      "No Disease Predicted",
                                      style: TextStyle(
                                          fontSize: 17.5,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    )));
                        }
                      }
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ListView(
                          children: predictedDiseases,
                        ),
                      );
                    }
                  }),
            ),
            ElevatedButton(
                onPressed: () {
                  getOrganName();
                  storeResults();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookAppointment(
                        _organName,
                        selectedSymptomsList,
                        priorityMap,
                      ),
                    ),
                  );
                },
                child: const Text("Book Appointment")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                  storeResults();
                },
                child: const Text("Home")),
          ],
        ));
  }

  void getOrganName() async {
    await FirebaseFirestore.instance
        .collection('diagnosis')
        .doc(_organId)
        .get()
        .then((value) {
      setState(() {
        _organName = value.get("name");
        print(_organName);
      });
    });
  }

  void getCurrentUserInfo() async {
    final uid = currentUid;
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    _patientName = doc['firstName'];
    _patientState = doc['state'];
    _patientCity = doc['city'];
    _patientLat = doc['latitude'];
    _patientLong = doc['longitude'];
  }

  void storeResults() async {
    await FirebaseFirestore.instance.collection('diagnosis_results').doc().set({
      "selectedOrgan": _organName,
      "selectedSymptoms": selectedSymptomsList,
      "predictedDisease": priorityMap,
      "patientId": currentUid,
      "timestamp": Timestamp.now(),
      "patientName": _patientName,
      "patientState": _patientState,
      "patientCity": _patientCity,
      "patientLat": _patientLat,
      "patientLong": _patientLong,
    });

    await FirebaseFirestore.instance
        .collection("epidemic_prediction")
        .doc()
        .set({
      "organId": _organId,
      "organName": _organName,
      "timestamp": Timestamp.now(),
      "predictedDisease": priorityMap.keys.elementAt(0).toString(),
      "predictedDisease2": priorityMap.keys.elementAt(1).toString(),
      "patientId": currentUid,
      "patientState": _patientState,
      "patientCity": _patientCity,
      "patientLat": _patientLat,
      "patientLong": _patientLong,
    });
  }
}
