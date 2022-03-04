import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './predict_disease.dart';
import 'package:getwidget/getwidget.dart';

class SelectSymptoms extends StatefulWidget {
  List<String> allSymptomsList;
  String organName;
  SelectSymptoms(this.allSymptomsList, this.organName);
  @override
  _SelectSymptomsState createState() =>
      _SelectSymptomsState(this.allSymptomsList, this.organName);
}

class _SelectSymptomsState extends State<SelectSymptoms> {
  String _organName = "";
  List<bool> isSymptomSelected = [];
  List<String> selectedSymptomsList = [];
  List<String> _allSymptomsList = [];
  _SelectSymptomsState(List<String> symList, String _organ) {
    _allSymptomsList = symList;
    _organName = _organ;
    for (int i = 0; i < _allSymptomsList.length; i++) {
      isSymptomSelected.add(false);
    }
  }

  // getAllSymptoms() async {
  //   var firestore = FirebaseFirestore.instance;
  //   QuerySnapshot qn = await firestore
  //       .collection("diagnosis")
  //       .doc(organName)
  //       .collection("diseases")
  //       .get();
  //   List<DocumentSnapshot> list = qn.docs;
  //   for (var i = 0; i < list.length; i++) {
  //     for (var j = 0; j < list[i].get("symptoms").length; j++) {
  //       symptomsList.add(list[i].get("symptoms")[j]);
  //     }
  //   }
  //   print(symptomsList);
  // }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Symptoms"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: _allSymptomsList.map((e) {
                return
                    // CheckboxListTile(
                    //   // activeColor: Colors.white,
                    //   selectedTileColor: Colors.red
                    //   ti,
                    //   checkColor: Colors.green,
                    //   selected: true,
                    //   value: isSymptomSelected[_allSymptomsList.indexOf(e)],
                    //   onChanged: (bool? newValue) {
                    //     setState(() {
                    //       newValue == true
                    //           ? selectedSymptomsList.add(e)
                    //           : selectedSymptomsList.remove(e);
                    //       isSymptomSelected[_allSymptomsList.indexOf(e)] =
                    //           !isSymptomSelected[_allSymptomsList.indexOf(e)];
                    //     });
                    //   },
                    //   title: Text(e),
                    // );
                    GFCheckboxListTile(
                  size: 26,
                  activeBgColor: Colors.green,
                  activeBorderColor: Colors.blue,
                  selected: true,
                  customBgColor: Colors.yellow,
                  activeIcon: Icon(
                    Icons.check,
                    size: 16,
                    color: Colors.white,
                  ),
                  type: GFCheckboxType.circle,
                  value: isSymptomSelected[_allSymptomsList.indexOf(e)],
                  onChanged: (bool? newValue) {
                    setState(() {
                      newValue == true
                          ? selectedSymptomsList.add(e)
                          : selectedSymptomsList.remove(e);
                      isSymptomSelected[_allSymptomsList.indexOf(e)] =
                          !isSymptomSelected[_allSymptomsList.indexOf(e)];
                    });
                  },
                  title: Text(e),
                  inactiveIcon: null,
                );
              }).toList(),
            ),
          ),
          TextButton(
              onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PredictDisease(selectedSymptomsList, _organName)),
                  ),
              child: const Text("Predict")),
        ],
      ),
      // body: StreamBuilder<QuerySnapshot>(
      //   stream: FirebaseFirestore.instance
      //       .collection('diagnosis')
      //       .doc(organName)
      //       .collection("diseases")
      //       .snapshots(),
      //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //     if (!snapshot.hasData) {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     } else {
      //       return Column(
      //         children: [
      //           Expanded(
      //             child: ListView(
      //               children: snapshot.data!.docs.map((document) {
      //                 List<dynamic> symptomsList = document.get("symptoms");
      //                 print("slist : " +
      //                     symptomsList[0].toString() +
      //                     " " +
      //                     snapshot.data!.docs.length.toString());
      //                 for (var i = 0; i < symptomsList.length; i++) {
      //                   print(symptomsList[i]);
      //                   isSymptomSelected.add(false);
      //                 }
      //                 print(
      //                     "size of bool " + isSymptomSelected.length.toString());
      //                 return ListView(
      //                   shrinkWrap: true,
      //                   physics: const ClampingScrollPhysics(),
      //                   children: symptomsList.map((e) {
      //                     return CheckboxListTile(
      //                         value: isSymptomSelected[symptomsList.indexOf(e)],
      //                         onChanged: (bool? newValue) {
      //                           setState(() {
      //                             newValue == true
      //                                 ? selectedSymptomsList.add(e)
      //                                 : selectedSymptomsList.remove(e);
      //                             isSymptomSelected[symptomsList.indexOf(e)] =
      //                                 !isSymptomSelected[symptomsList.indexOf(e)];
      //                           });
      //                         },
      //                         title: Text(e));
      //                   }).toList(),
      //                 );
      //               }).toList(),
      //             ),
      //           ),
      //           TextButton(
      //               onPressed: () => Navigator.push(
      //                     context,
      //                     MaterialPageRoute(
      //                         builder: (context) =>
      //                             PredictDisease(selectedSymptomsList)),
      //                   ),
      //               child: const Text("Submit")),
      //         ],
      //       );
      //     }
      //   },
      // ),
    );
  }
}
