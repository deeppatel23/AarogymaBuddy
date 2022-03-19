import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../global.dart';

class ViewProfile extends StatefulWidget {
  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  String firstName = "";
  String firstNameen = "";
  String firstNamehi = "";
  String firstNamegu = "";
  String lastName = "";
  String lastNameen = "";
  String lastNamehi = "";
  String lastNamegu = "";
  String email = "";
  String emailen = "";
  String emailhi = "";
  String emailgu = "";
  String mobile = "";
  String state = "";
  String stateen = "";
  String statehi = "";
  String stategu = "";
  String city = "";
  String cityen = "";
  String cityhi = "";
  String citygu = "";
  String aadhar = "";
  List<String> languages = ["Hindi", "Gujarati", "English"];

  void getUserInfo() async {
    final uid = currentUid;
    final doc =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    setState(() {
      firstNameen = doc['firstName'];
      firstNamehi = doc['firstNamehi'];
      firstNamegu = doc['firstNamegu'];
      lastNameen = doc['lastName'];
      lastNamehi = doc['lastNamehi'];
      lastNamegu = doc['lastNamegu'];
      emailen = doc['email'];
      emailhi = doc['emailhi'];
      emailgu = doc['emailgu'];
      mobile = doc['mobile'];
      stateen = doc['state'];
      statehi = doc['statehi'];
      stategu = doc['stategu'];
      cityen = doc['city'];
      cityhi = doc['cityhi'];
      citygu = doc['citygu'];
      aadhar = doc['aadhar'];
      print(firstNameen);

      if (selectedLang == "") {
        selectedLang = "";
        firstName = firstNameen;
        lastName = lastNameen;
        email = emailen;
        state = stateen;
        city = cityen;
      } else if (selectedLang == "hi") {
        selectedLang = "hi";
        firstName = firstNamehi;
        lastName = lastNamehi;
        email = emailhi;
        state = statehi;
        city = cityhi;
      } else if (selectedLang == "gu") {
        selectedLang = "gu";
        firstName = firstNamegu;
        lastName = lastNamegu;
        email = emailgu;
        state = stategu;
        city = citygu;
      }
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
        backgroundColor: globalBackgroundColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("images/patient.png"),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "First Name: " + firstName,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Text(
            "Last Name: " + lastName,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Text(
            "Email: $email",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Text(
            "Mobile: $mobile",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Text(
            "State: " + state,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Text(
            "City: " + city,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Text(
            "Aadhar: $aadhar",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: DropdownButton<String>(
              borderRadius: BorderRadius.circular(10),
              hint: Text('Select Language'),
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
                    firstName = firstNameen;
                    lastName = lastNameen;
                    email = emailen;
                    state = stateen;
                    city = cityen;
                  } else if (lang.toString() == "Hindi") {
                    selectedLang = "hi";
                    firstName = firstNamehi;
                    lastName = lastNamehi;
                    email = emailhi;
                    state = statehi;
                    city = cityhi;
                  } else if (lang.toString() == "Gujarati") {
                    selectedLang = "gu";
                    firstName = firstNamegu;
                    lastName = lastNamegu;
                    email = emailgu;
                    state = stategu;
                    city = citygu;
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
