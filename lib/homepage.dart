import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Diagnosis/select_organ.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _appName = "Healthcare";
  String _appDescription = "";
  bool showDes = false;

  getAppDetails() async {
    await FirebaseFirestore.instance
        .collection('global_details')
        .doc('app')
        .get()
        .then((value) {
      _appName = value.data()!['name'];
      _appDescription = value.data()!['description'];
    });
  }

  @override
  void initState() {
    getAppDetails();
    showDes = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appName == "" ? "App Name" : _appName),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await getAppDetails();
          setState(() {});
        },
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
              Widget>[
            TextButton(
                onPressed: () {
                  setState(() {
                    getAppDetails();
                    showDes = !showDes;
                  });
                },
                child: const Text("Hello Healthcare App")),
            showDes == true
                ? Text(
                    _appDescription == "" ? "App Description" : _appDescription)
                : Container(),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SelectOrgan()),
              ),
              child: const Text("Select Organ"),
            ),
          ]),
        ),
      ),
    );
  }
}
