import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'homepage.dart';
import 'Login/register_user.dart';

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
      firstWidget = HomePage();
    } else {
      firstWidget = const Login();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Healthcare App',
      theme: ThemeData(
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
