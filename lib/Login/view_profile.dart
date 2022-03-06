import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../global.dart';

class ViewProfile extends StatefulWidget {
  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  String firstName = "";
  String firstNamehi = "";
  String firstNamegu = "";
  String lastName = "";
  String lastNamehi = "";
  String lastNamegu = "";
  String email = "";
  String emailhi = "";
  String emailgu = "";
  String mobile = "";
  String state = "";
  String statehi = "";
  String stategu = "";
  String city = "";
  String cityhi = "";
  String citygu = "";
  String aadhar = "";
  List<String> languages = ["Hindi", "Gujarati", "English"];

  void getUserInfo() async {
    final uid = currentUid;
    final doc =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    setState(() {
      firstName = doc['firstName'];
      firstNamehi = doc['firstNamehi'];
      firstNamegu = doc['firstNamegu'];
      lastName = doc['lastName'];
      lastNamehi = doc['lastNamehi'];
      lastNamegu = doc['lastNamegu'];
      email = doc['email'];
      emailhi = doc['emailhi'];
      emailgu = doc['emailgu'];
      mobile = doc['mobile'];
      state = doc['state'];
      statehi = doc['statehi'];
      stategu = doc['stategu'];
      city = doc['city'];
      cityhi = doc['cityhi'];
      citygu = doc['citygu'];
      aadhar = doc['aadhar'];
      print(firstName);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Center(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: DropdownButton<String>(
              borderRadius: BorderRadius.circular(10),
              hint: Text('Select City'),
              value: selectedLang == ""
                  ? "English"
                  : selectedLang == "hi"
                      ? "Hindi"
                      : "Gujarati",
              isExpanded: true,
              items: languages.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (lang) {
                setState(() {
                  print(lang.toString());
                  if (lang.toString() == "English") {
                    selectedLang = "";
                  } else if (lang.toString() == "Hindi") {
                    selectedLang = "hi";
                  } else if (lang.toString() == "Gujarati") {
                    selectedLang = "gu";
                  }
                });
              },
            ),
          ),
          SizedBox(height: 20),
          Text(selectedLang == "hi"
              ? firstNamehi
              : selectedLang == "gu"
                  ? firstNamegu
                  : firstName),
          Text(selectedLang == "hi"
              ? lastNamehi
              : selectedLang == "gu"
                  ? lastNamegu
                  : lastName),
          Text("Email: $email"),
          Text("Mobile: $mobile"),
          Text(selectedLang == "hi"
              ? statehi
              : selectedLang == "gu"
                  ? stategu
                  : state),
          Text(selectedLang == "hi"
              ? cityhi
              : selectedLang == "gu"
                  ? citygu
                  : city),
          Text("Aadhar: $aadhar"),
        ],
      )),
    );
  }
}
