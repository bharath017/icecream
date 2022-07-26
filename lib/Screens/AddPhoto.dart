import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:icecream/Screens/PaymentScreen.dart';
import 'package:icecream/global/global.dart';
import 'package:icecream/utils/size_config.dart';
import 'package:image_picker/image_picker.dart';

class AddPhoto extends StatefulWidget {
  const AddPhoto({super.key});

  @override
  State<AddPhoto> createState() => _AddPhotoState();
}

class _AddPhotoState extends State<AddPhoto> {
  FirebaseStorage storage = FirebaseStorage.instance;
  late Uint8List imageBytes;
  bool loaded = false;
  String errorMsg = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 80,
            ),
            _photo != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.file(
                      _photo!,
                      width: 140,
                      height: 140,
                      fit: BoxFit.cover,
                    ),
                  )
                : CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage('assets/user.jpg'),
                  ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: Text(
                "Add your photo for safer and smoother deliveries",
                style: TextStyle(
                    fontSize: SizeConfig.textMultiplier * 2.1,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Text(
                "Drivers can only view your photo during the delivery and will not be able to access it once the delivery is completed",
                style: TextStyle(fontSize: SizeConfig.textMultiplier * 1.5),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(child: Container()),
            _photo == null
                ? Container(
                    color: Colors.white,
                    width: SizeConfig.widthMultiplier * 60,
                    height: 50,
                    child: TextButton(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 71, 207, 252)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      side: BorderSide(
                                          color: Color.fromARGB(
                                              255, 71, 207, 252))))),
                      onPressed: () {
                        _showPicker(context);
                      },
                      child: Text(
                        "Take Photo",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Raleway',
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  )
                : Container(),
            SizedBox(
              height: 10,
            ),
            _photo == null
                ? Container(
                    color: Colors.transparent,
                    width: SizeConfig.widthMultiplier * 60,
                    height: 50,
                    child: TextButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      side: BorderSide(
                                          color: Color.fromARGB(
                                              255, 71, 207, 252))))),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (c) => PaymentMethod()));
                      },
                      child: Text(
                        "Later",
                        style: TextStyle(
                          color: Color.fromARGB(255, 71, 207, 252),
                          fontFamily: 'Raleway',
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  )
                : Container(
                    color: Colors.transparent,
                    width: SizeConfig.widthMultiplier * 80,
                    height: 50,
                    child: TextButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      side: BorderSide(
                                          color: Color.fromARGB(
                                              255, 71, 207, 252))))),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (c) => PaymentMethod()));
                      },
                      child: Text(
                        "Looking Good...;) Let's go ahead...!!",
                        style: TextStyle(
                          color: Color.fromARGB(255, 71, 207, 252),
                          fontFamily: 'Raleway',
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
            SizedBox(
              height: 30,
            ),
          ]),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = currentFirebaseUser!.uid;
    final destination = 'files/$fileName';

    try {
      final ref = FirebaseStorage.instance.ref(destination);
      await ref.putFile(_photo!);
    } catch (e) {
      print('error occured');
    }
  }
}
