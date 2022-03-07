import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PredictionAnalysis extends StatefulWidget {
  const PredictionAnalysis({Key? key}) : super(key: key);

  @override
  State<PredictionAnalysis> createState() => _PredictionAnalysisState();
}

class _PredictionAnalysisState extends State<PredictionAnalysis> {
  Map<String, int> _dataFromCity = {};
  Map<String, int> _dataFromDisease = {};
  List<String> provincesList = ['Rajkot', 'Ahemdabad', 'Baroda'];
  List<String> diseasesList = [
    'Cataract',
    'Conjunctivitis',
    'Diabetic Retinopathy',
    'Dry eye Syndrome',
    'Eye Strain',
    'Glaucoma',
    'Night Blindness',
    'Refractive Errors',
    'Heart disease symptoms caused by heart infection(endocardium)',
    'atherosclerosis(buildup of fatty plaques in your arteries)',
    'cardiomyopathy',
    'heart disease caused by heart defects',
    'valvular heart disease',
  ];
  String? selectedCity;
  String? selectedDisease;
  @override
  void initState() {
    selectedCity = provincesList[0];
    selectedDisease = diseasesList[0];
    super.initState();
    _getDataFromCity("Rajkot");
    _getDataFromDisease(
        "Heart disease symptoms caused by heart infection(endocardium)");
  }

  void _getDataFromCity(String city) async {
    await FirebaseFirestore.instance
        .collection("epidemic_prediction")
        .where("patientCity", isEqualTo: city)
        .get()
        .then((value) => value.docs.forEach((element) {
              setState(() {
                bool contain = _dataFromCity.containsKey(
                    element.data()['organName'] +
                        element.data()['predictedDisease']);
                if (contain) {
                  int? temp = _dataFromCity[element.data()['organName'] +
                      element.data()['predictedDisease']];
                  _dataFromCity[element.data()['organName'] +
                      element.data()['predictedDisease']] = temp! + 1;
                } else {
                  _dataFromCity[element.data()['organName'] +
                      element.data()['predictedDisease']] = 1;
                }
              });
              // _data.containsKey(element.data()['organName'] +
              //         element.data()['predictedDisease'])
              //     ? _data[element.data()['organName'] +
              //             element.data()['predictedDisease']]! +
              //         1
              //     : _data[element.data()['organName'] +
              //         element.data()['predictedDisease']] = 1;

              print(element.data()['organName']);
            }));

    print(_dataFromCity);
  }

  void _getDataFromDisease(String disease) async {
    await FirebaseFirestore.instance
        .collection("epidemic_prediction")
        .where("predictedDisease", isEqualTo: disease)
        .get()
        .then((value) => value.docs.forEach((element) {
              setState(() {
                bool contain =
                    _dataFromDisease.containsKey(element.data()['patientCity']);
                if (contain) {
                  int? temp = _dataFromDisease[element.data()['patientCity']];
                  _dataFromDisease[element.data()['patientCity']] = temp! + 1;
                } else {
                  _dataFromDisease[element.data()['patientCity']] = 1;
                }
              });

              print(element.data()['patientCity']);
            }));

    print(_dataFromDisease);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Prediction Analysis"),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: DropdownButton<String>(
                borderRadius: BorderRadius.circular(10),
                hint: Text('Select City'),
                value: selectedCity,
                isExpanded: true,
                items: provincesList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (province) {
                  setState(() {
                    selectedCity = province;
                  });
                },
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  _getDataFromCity(selectedCity!);
                  setState(() {
                    _dataFromCity = {};
                  });
                },
                child: Text("Show Result")),
            Container(
              child: Text(_dataFromCity.toString()),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: DropdownButton<String>(
                borderRadius: BorderRadius.circular(10),
                hint: Text('Select Disease'),
                value: selectedDisease,
                isExpanded: true,
                items: diseasesList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (d) {
                  setState(() {
                    selectedDisease = d;
                  });
                },
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  _getDataFromDisease(selectedDisease!);
                  setState(() {
                    _dataFromDisease = {};
                  });
                },
                child: Text("Show Result")),
            Container(
              child: Text(_dataFromDisease.toString()),
            )
          ],
        ),
      ),
    );
  }
}
