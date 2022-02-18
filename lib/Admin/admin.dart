import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthcareapp/Login/user_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthcareapp/admin/admin_home.dart';
import 'package:healthcareapp/admin/error.dart';
import 'package:healthcareapp/global.dart';

enum LoginScreen { SHOW_MOBILE_ENTER_WIDGET, SHOW_OTP_FORM_WIDGET }

class admin extends StatefulWidget {
  const admin({Key? key}) : super(key: key);

  @override
  _adminState createState() => _adminState();
}

class _adminState extends State<admin> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  LoginScreen currentState = LoginScreen.SHOW_MOBILE_ENTER_WIDGET;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationID = "";

  void SignOutME() async {
    await _auth.signOut();
  }

  /// Check If Document Exists
  Future<bool> checkIfUserExists() async {
    try {
      // Get reference to Firestore collection
      var collectionRef = FirebaseFirestore.instance.collection('admin');
      var doc = await collectionRef.doc(_auth.currentUser!.uid).get();
      print(doc.data());
      print(doc.exists);
      if (doc.exists) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  void signInWithPhoneAuthCred(AuthCredential phoneAuthCredential) async {
    try {
      final authCred = await _auth.signInWithCredential(phoneAuthCredential);
      final exists = await checkIfUserExists();
      print("exists: $exists");
      userType = "admin";

      if (authCred.user != null) {
        if (exists) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => adminHome()));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => error()));
        }
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Some Error Occured. Try Again Later')));
    }
  }

  showMobilePhoneWidget(context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('images/login.png'), fit: BoxFit.cover),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(right: 120, top: 130),
            child: Text(
              'Welcome Back',
              style: TextStyle(color: Colors.white, fontSize: 33),
            ),
          ),
          Spacer(),
          Text(
            "Verify Your Phone Number",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 7,
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(left: 35, right: 35),
              child: TextField(
                controller: phoneController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: "Enter Your PhoneNumber",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async {
              await _auth.verifyPhoneNumber(
                  phoneNumber: "+91${phoneController.text}",
                  verificationCompleted: (phoneAuthCredential) async {},
                  verificationFailed: (verificationFailed) {
                    print(verificationFailed);
                  },
                  codeSent: (verificationID, resendingToken) async {
                    setState(() {
                      currentState = LoginScreen.SHOW_OTP_FORM_WIDGET;
                      this.verificationID = verificationID;
                    });
                  },
                  codeAutoRetrievalTimeout: (verificationID) async {});
            },
            child: Text("Send OTP"),
          ),
          SizedBox(
            height: 16,
          ),
          Spacer()
        ],
      ),
    );
  }

  showOtpFormWidget(context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('images/login.png'), fit: BoxFit.cover),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(),
          Spacer(),
          Text(
            "ENTER YOUR OTP",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 7,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.only(left: 35, right: 35),
            child: TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  hintText: "Enter Your OTP"),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                AuthCredential phoneAuthCredential =
                    PhoneAuthProvider.credential(
                        verificationId: verificationID,
                        smsCode: otpController.text);
                signInWithPhoneAuthCred(phoneAuthCredential);
                print(otpController.text);
              },
              child: Text("Verify")),
          SizedBox(
            height: 16,
          ),
          Spacer()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentState == LoginScreen.SHOW_MOBILE_ENTER_WIDGET
          ? showMobilePhoneWidget(context)
          : showOtpFormWidget(context),
    );
  }
}
