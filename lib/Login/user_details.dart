import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../homepage.dart';

class UserDetails extends StatefulWidget {
  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController aadhar = TextEditingController();
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('User Details'),
        ),
        body: Form(
            child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: firstNameController,
                  decoration: const InputDecoration(hintText: 'First name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'You must enter the first name';
                    } else if (value.length > 15) {
                      return 'First name cant have more than 15 letters';
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: lastNameController,
                  decoration: const InputDecoration(hintText: 'Last name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'You must enter the Last name';
                    } else if (value.length > 15) {
                      return 'Last name cant have more than 15 letters';
                    }
                  },
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(12.0),
              //   child: TextFormField(
              //     controller: mobile,
              //     decoration: const InputDecoration(hintText: 'mobile'),
              //     validator: (value) {
              //       if (value!.isEmpty) {
              //         return 'You must enter the mobile';
              //       } else if (value.length > 15) {
              //         return 'mobile cant have more than 15 letters';
              //       }
              //     },
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: aadhar,
                  decoration: const InputDecoration(hintText: 'aadhar'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'You must enter the first name';
                    } else if (value.length > 15) {
                      return 'First name cant have more than 15 letters';
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: email,
                  decoration: const InputDecoration(hintText: 'email'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'You must enter the first name';
                    } else if (value.length > 15) {
                      return 'First name cant have more than 15 letters';
                    }
                  },
                ),
              ),
              ElevatedButton(
                child: Text('Register'),
                onPressed: () {
                  validateAndUpload();
                },
              )
            ],
          ),
        )));
  }

  void validateAndUpload() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    User currentUser = await auth.currentUser!;
    print("User id" + currentUser.uid);
    _firestore.collection('users').doc(currentUser.uid).set({
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'mobile': currentUser.phoneNumber,
      'aadhar': aadhar.text,
      'email': email.text,
      'id': currentUser.uid,
    }).then(
      (value) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      ),
    );
  }
}
