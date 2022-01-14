import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PredictDisease extends StatefulWidget {
  final List<String> finalSymptoms;
  String organName;
  PredictDisease(this.finalSymptoms, this.organName);
  @override
  _PredictDiseaseState createState() =>
      _PredictDiseaseState(this.finalSymptoms, this.organName);
}

class _PredictDiseaseState extends State<PredictDisease> {
  List<String> selectedSymptomsList = [];
  String _organName = "";
  Map<String, int> priorityMap = {};
  _PredictDiseaseState(List<String> symptoms, String organ) {
    selectedSymptomsList = symptoms;
    _organName = organ;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Predict Disease"),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('diagnosis')
                .doc(_organName)
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
                  for (var symptom in disease.get("symptoms")) {
                    if (selectedSymptomsList.contains(symptom)) {
                      priorityMap[disease.id] =
                          priorityMap.containsKey(disease.id)
                              ? priorityMap[disease.id]! + 1
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
            }));
  }
}
