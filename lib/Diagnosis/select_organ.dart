import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './select_symptoms.dart';
import './predict_disease.dart';

class SelectOrgan extends StatefulWidget {
  const SelectOrgan({Key? key}) : super(key: key);

  @override
  _SelectOrganState createState() => _SelectOrganState();
}

class _SelectOrganState extends State<SelectOrgan> {
  List<String> allSymptoms = [];

  getAllSymptoms(String organName) async {
    allSymptoms = [];
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore
        .collection("diagnosis")
        .doc(organName)
        .collection("diseases")
        .get();
    List<DocumentSnapshot> list = qn.docs;
    for (var i = 0; i < list.length; i++) {
      for (var j = 0; j < list[i].get("symptoms").length; j++) {
        allSymptoms.add(list[i].get("symptoms")[j]);
      }
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectSymptoms(
          allSymptoms,
          organName,
        ),
      ),
    );
    print(allSymptoms);
  }

  void initState() {
    super.initState();
    allSymptoms = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Organ"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('diagnosis').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              children: snapshot.data!.docs.map((document) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(document.get("name").toString()),
                        onTap: () {
                          getAllSymptoms(document.id);
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) =>
                          //           PredictDisease(allSymptoms)),
                          // );
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
