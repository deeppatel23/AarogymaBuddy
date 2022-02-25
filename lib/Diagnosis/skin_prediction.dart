import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SkinPrediction extends StatefulWidget {
  @override
  _SkinPredictionState createState() => _SkinPredictionState();
}

enum Answers { camera, gallery }

class _SkinPredictionState extends State<SkinPrediction> {
  File? _image;
  String _imageUrl = "";
  late List _outputs;
  var image;
  final ImagePicker _picker = ImagePicker();
  String res = "";

  String _value = "";
  // ignore: unused_element
  void _setValue(String value) => setState(() {
        if (_value == "camera") {
          pickImageCamera();
        } else if (_value == "gallery") {
          pickImageGallery();
        }
      });

  pickImageCamera() async {
    // ignore: deprecated_member_use
    image = await _picker.pickImage(source: ImageSource.camera);
  }

  pickImageGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    final File? file = File(image!.path);
    setState(() {
      _image = file;
      res = "loading";
    });
    predictApiCall(file!);
  }

  void predictApiCall(File img) async {
    var url = Uri.parse("https://skip-disease-predictor.herokuapp.com/predict");
    var request = http.MultipartRequest("POST", url);
    request.files.add(http.MultipartFile.fromBytes(
        'file', img.readAsBytesSync(),
        filename: 'image.jpg'));
    print("testing called");
    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    print("res : " + respStr);
    res = respStr;
    setState(() {
      res = respStr;
    });
    storeResults();
    // print("res : " + Post.fromJson(json.decode()).toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Skin Disease Predictor",
          style: TextStyle(color: Colors.white, fontSize: 23),
        ),
        backgroundColor: Color.fromRGBO(14, 49, 80, 1),
        elevation: 0,
      ),
      body: Container(
          // color: Colors.yellow[50],
          color: Color.fromRGBO(224, 140, 255, 0.2),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.all(15),
                    // color: Colors.green,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _image == null
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.65,
                                alignment: Alignment.center,
                                child: const Text(
                                    "Choose an Image to predict Disease"),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.blueGrey,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.65,
                                decoration: BoxDecoration(
                                  //  Image.file(_image, fit: BoxFit.contain),
                                  image: DecorationImage(
                                    image: FileImage(_image!),
                                    fit: BoxFit.contain,
                                  ),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.blueGrey,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                        const SizedBox(
                          height: 20,
                        ),
                        res == "loading"
                            ? CircularProgressIndicator()
                            : Text(res),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Pick Image',
        onPressed: () {
          pickImageGallery();
        },
        child: const Icon(
          Icons.add_a_photo,
          size: 20,
          color: Colors.white,
        ),
        backgroundColor: const Color.fromRGBO(14, 49, 80, 1),
      ),
    );
  }

  void storeResults() async {
    print("Store Res called");
    await FirebaseStorage.instance
        .ref()
        .child(
            "skin_images/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg")
        .putFile(_image!)
        .then((value) {
      value.ref.getDownloadURL().then((url) {
        setState(() {
          _imageUrl = url;
        });
        print("Inside then");
        FirebaseFirestore.instance.collection('skin_diagnosis').doc().set({
          'image': url,
          'predictedDisease': res,
        });
      });
    });
  }
}
