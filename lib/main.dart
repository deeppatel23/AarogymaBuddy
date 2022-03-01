import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:healthcareapp/Admin/admin_home.dart';
import 'package:healthcareapp/Doctor/doctor_home.dart';
import 'package:healthcareapp/global.dart';
import 'homepage.dart';
import 'Login/register_user.dart';
import 'Login/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Get the firebase user
    User? firebaseUser = FirebaseAuth.instance.currentUser;
// Define a widget
    Widget firstWidget;

// Assign widget based on availability of currentUser
    if (firebaseUser != null) {
      if (userType == "admin") {
        firstWidget = adminHome();
      } else if (userType == "doctor") {
        firstWidget = doctorHome();
      } else {
        firstWidget = HomePage();
      }
      currentUid = firebaseUser.uid;
      print(currentUid);
    } else {
      firstWidget = const WelcomeScreen();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Healthcare App',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primarySwatch: Colors.blue,
      ),
      home: firstWidget,
    );
  }

  // void checkForLogin(BuildContext context) async {
  //   final FirebaseAuth auth = FirebaseAuth.instance;
  //   User currentUser = await auth.currentUser!;
  //   if (currentUser != null) {
  //     Navigator.of(context)
  //         .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
  //   }
  //   Navigator.of(context)
  //       .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
  // }
}
