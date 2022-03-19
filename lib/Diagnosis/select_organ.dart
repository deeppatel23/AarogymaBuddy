import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthcareapp/global.dart';
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
      for (var j = 0; j < list[i].get("symptoms" + selectedLang).length; j++) {
        allSymptoms.add(list[i].get("symptoms" + selectedLang)[j]);
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
        backgroundColor: globalBackgroundColor,
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
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                              document.get("name" + selectedLang).toString()),
                          onTap: () {
                            getAllSymptoms(document.id);
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) =>
                            //           PredictDisease(allSymptoms)),
                            // );
                          },
                          leading: Image(
                            image: AssetImage('images/organs/' +
                                document.get("name").toString() +
                                '.png'),
                          ),
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromARGB(255, 72, 175, 235),
                              blurRadius: 5,
                              offset: Offset(0, 1))
                        ]),
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
