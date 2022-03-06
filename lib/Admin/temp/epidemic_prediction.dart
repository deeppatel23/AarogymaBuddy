import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:healthcareapp/Admin/temp/disease.dart';

class DiseaseChartPage extends StatefulWidget {
  @override
  _DiseaseChartPageState createState() {
    return _DiseaseChartPageState();
  }
}

class _DiseaseChartPageState extends State<DiseaseChartPage> {
  late List<charts.Series<Disease, String>> _seriesBarData;
  late List<Disease> mydata;
  Map<String, int> _data = {};
  _generateData(mydata) {
    // ignore: deprecated_member_use
    _seriesBarData = <charts.Series<Disease, String>>[];
    _seriesBarData.add(
      charts.Series(
        domainFn: (Disease sales, _) => sales.name.toString(),
        measureFn: (Disease sales, _) => sales.count,
        id: 'Sales',
        data: mydata,
        labelAccessorFn: (Disease row, _) => "${row.name}",
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  List<Disease> diseaseData = [];
  void _getData() async {
    await FirebaseFirestore.instance
        .collection("epidemic_prediction")
        .get()
        .then((value) => value.docs.forEach((element) {
              _data.containsKey(element.data()['organName'] +
                      element.data()['predictedDisease'])
                  ? _data[element.data()['organName'] +
                          element.data()['predictedDisease']]! +
                      1
                  : _data[element.data()['organName'] +
                      element.data()['predictedDisease']] = 1;

              int? temp = _data[element.data()['organName'] +
                  element.data()['predictedDisease']];
              diseaseData.add(
                Disease(
                    temp!,
                    element.data()['organName'].toString() +
                        element.data()['predictedDisease'].toString()),
              );
            }));
    print(_data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Disease')),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('epidemic_prediction')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          return _buildChart(context, diseaseData);
        }
      },
    );
  }

  Widget _buildChart(BuildContext context, List<Disease> saledata) {
    mydata = saledata;
    _generateData(mydata);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Expanded(
            child: Column(
              children: <Widget>[
                Text(
                  'Sales by Year',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  child: charts.BarChart(
                    _seriesBarData,
                    animate: true,
                    animationDuration: Duration(seconds: 5),
                    behaviors: [
                      new charts.DatumLegend(
                        entryTextStyle: charts.TextStyleSpec(
                            color: charts.MaterialPalette.purple.shadeDefault,
                            fontFamily: 'Georgia',
                            fontSize: 18),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
