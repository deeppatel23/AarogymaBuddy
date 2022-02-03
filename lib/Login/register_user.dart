import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthcareapp/Login/user_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../homepage.dart';

enum LoginScreen { SHOW_MOBILE_ENTER_WIDGET, SHOW_OTP_FORM_WIDGET }

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
      var collectionRef = FirebaseFirestore.instance.collection('users');
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

      if (authCred.user != null) {
        if (exists) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => UserDetails()));
        }
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Some Error Occured. Try Again Later')));
    }
  }

  showMobilePhoneWidget(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
          child: TextField(
            controller: phoneController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                hintText: "Enter Your PhoneNumber"),
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
            child: Text("Send OTP")),
        SizedBox(
          height: 16,
        ),
        Spacer()
      ],
    );
  }

  showOtpFormWidget(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
        Center(
          child: TextField(
            controller: otpController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                hintText: "Enter Your OTP"),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
            onPressed: () {
              AuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
                  verificationId: verificationID, smsCode: otpController.text);
              signInWithPhoneAuthCred(phoneAuthCredential);
              print(otpController.text);
            },
            child: Text("Verify")),
        SizedBox(
          height: 16,
        ),
        Spacer()
      ],
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
