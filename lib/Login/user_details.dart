import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';
// import 'package:permission_handler/permission_handler.dart';
import '../global.dart';
import '../homepage.dart';
import '../multilang.dart';

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
  //location var
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;
  //dropdown var
  List<String> states = ['Gujarat', 'Maharastra'];
  List<String> gujarat = ['Rajkot', 'Ahemdabad', 'Baroda'];
  List<String> maharastra = ['Mumbai', 'Pune', 'Nasik'];
  List<String> provinces = [];
  String? selectedState;
  String? selectedCity;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // await _requestPermission();
    // _initLocationService();
    // location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    // location.enableBackgroundMode(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('images/register.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(right: 150, top: 130),
                  child: Text(
                    'User Details',
                    style: TextStyle(color: Colors.white, fontSize: 33),
                  ),
                ),
                SizedBox(
                  height: 70,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: firstNameController,
                    decoration: InputDecoration(
                      hintText: 'First name',
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      RegExp regex = new RegExp(r'^.{3,}$');
                      if (value!.isEmpty) {
                        return ("First Name cannot be Empty");
                      }
                      if (!regex.hasMatch(value)) {
                        return ("Enter Valid name(Min. 3 Character)");
                      }
                      return null;
                    },
                    onSaved: (value) {
                      firstNameController.text = value!;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                      hintText: 'Last name',
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      RegExp regex = new RegExp(r'^.{3,}$');
                      if (value!.isEmpty) {
                        return ("Last Name cannot be Empty");
                      }
                      if (!regex.hasMatch(value)) {
                        return ("Enter Valid lastname");
                      }
                      return null;
                    },
                    onSaved: (value) {
                      lastNameController.text = value!;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: aadhar,
                    decoration: InputDecoration(
                      hintText: 'Aadhar',
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      RegExp regex = new RegExp("\\d{12}");
                      if (value!.isEmpty) {
                        return ("aadhar number cannot be Empty");
                      }
                      if (!regex.hasMatch(value)) {
                        return ("Enter Valid aadhar number");
                      }
                      return null;
                    },
                    onSaved: (value) {
                      aadhar.text = value!;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ("Please Enter Your Email");
                      }
                      // reg expression for email validation
                      if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                          .hasMatch(value)) {
                        return ("Please Enter a valid email");
                      }
                      return null;
                    },
                    onSaved: (value) {
                      email.text = value!;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(child: Text("Get Location"), onPressed: () {
                    _initLocationService();
                  },), 
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: DropdownButton<String>(
                    borderRadius: BorderRadius.circular(10),
                    hint: Text('State'),
                    value: selectedState,
                    isExpanded: true,
                    items: states.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (state) {
                      if (state == 'Maharastra') {
                        provinces = maharastra;
                      } else if (state == 'Gujarat') {
                        provinces = gujarat;
                      } else {
                        provinces = [];
                      }
                      setState(() {
                        selectedCity = null;
                        selectedState = state;
                      });
                    },
                  ),
                ),

                // State Dropdown Ends here
                // City Dropdown
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: DropdownButton<String>(
                    borderRadius: BorderRadius.circular(10),
                    hint: Text('City'),
                    value: selectedCity,
                    isExpanded: true,
                    items: provinces.map((String value) {
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

                CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xff4c505b),
                  child: IconButton(
                    color: Colors.white,
                    onPressed: () {
                      validateAndUpload();
                    },
                    // icon: Icon(
                    icon: Image.asset('images/a/right-arrow.gif'),
                  ),
                ),
                // ),
                // RawMaterialButton(
                //   onPressed: () {},
                //   elevation: 2.0,
                //   fillColor: Colors.white,
                //   child: Icon(
                //     Icons.pause,
                //     size: 35.0,
                //   ),
                //   padding: EdgeInsets.all(15.0),
                //   shape: CircleBorder(),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // _requestPermission() async {
  //   var status = await Permission.location.request();
  //   if (status.isGranted) {
  //     print('done');
  //   } else if (status.isDenied) {
  //     _requestPermission();
  //   } else if (status.isPermanentlyDenied) {
  //     openAppSettings();
  //   }
  // }

  Future _initLocationService() async {
  var location = Location();

  var _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
        return;
    }
  }
  var permission = await location.hasPermission();
  if (permission == PermissionStatus.denied) {
    permission = await location.requestPermission();
    if (permission != PermissionStatus.granted) {
      return;
    }
  }

  var loc = await location.getLocation();
  print("${loc.latitude} ${loc.longitude}");
}
  

  void validateAndUpload() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final loc.LocationData _locationResult = await location.getLocation();

    String firstNamehi = await translate(firstNameController.text, 'en', 'hi');
    String firstNamegu = await translate(firstNameController.text, 'en', 'gu');

    String lastNamehi = await translate(lastNameController.text, 'en', 'hi');
    String lastNamegu = await translate(lastNameController.text, 'en', 'gu');

    String emailhi = await translate(email.text, 'en', 'hi');
    String emailgu = await translate(email.text, 'en', 'gu');

    String statehi = await translate(selectedState.toString(), 'en', 'hi');
    String stategu = await translate(selectedState.toString(), 'en', 'gu');

    String cityhi = await translate(selectedCity.toString(), 'en', 'hi');
    String citygu = await translate(selectedCity.toString(), 'en', 'gu');

   
    User currentUser = await auth.currentUser!;
    String? mobile = currentUser.phoneNumber;

     setState(() {
          patientFirstName = firstNameController.text;
          patientLastName = lastNameController.text;
          patientEmail = email.text;
          patientMobile = mobile.toString();
          patientAadhar = aadhar.text;
          patientState = selectedState!;
          patientCity = selectedCity!;
        });


    print("User id" + currentUser.uid);
    if (_formKey.currentState!.validate()) {
      _firestore.collection('users').doc(currentUser.uid).set({
        'firstName': firstNameController.text,
        'firstNamehi': firstNamehi,
        'firstNamegu': firstNamegu,
        'lastName': lastNameController.text,
        'lastNamehi': lastNamehi,
        'lastNamegu': lastNamegu,
        'mobile': currentUser.phoneNumber,
        'aadhar': aadhar.text,
        'email': email.text,
        'emailhi': emailhi,
        'emailgu': emailgu,
        'id': currentUser.uid,
        'latitude': _locationResult.latitude,
        'longitude': _locationResult.longitude,
        'state': selectedState,
        'statehi': statehi,
        'stategu': stategu,
        'city': selectedCity,
        'cityhi': cityhi,
        'citygu': citygu,
      }).then(
        (value) => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        ),
      );
    }
  }
}