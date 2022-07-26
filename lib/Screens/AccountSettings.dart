import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:icecream/Screens/AddPhoto.dart';
import 'package:icecream/Screens/EditUserDetails.dart';
import 'package:icecream/Screens/EnterAddress.dart';
import 'package:icecream/global/global.dart';
import 'package:icecream/utils/size_config.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  DatabaseReference? UsersRef;
  FirebaseStorage storage = FirebaseStorage.instance;

// final FirebaseStorage storage1 = FirebaseStorage(
//       app: Firestore.instance.app,
//       storageBucket: 'gs://my-project.appspot.com');

  late Uint8List imageBytes;
  bool loaded = false;
  String errorMsg = "";
  void initState() {
    super.initState();
    storage
        .ref()
        .child('files')
        .child(currentFirebaseUser!.uid)
        .getData(10000000)
        .then((data) => setState(() {
              loaded = true;
              imageBytes = data!;
            }))
        .catchError((e) => setState(() {
              errorMsg = e.error;
            }));
    WidgetsBinding.instance.addPostFrameCallback((_) => getUserDetails());
  }

  String userName = '';
  String MailId = '';
  String mobile = '';
  String homeAddress = '';
  String officeAddress = '';
  var address = {};
  var ofAddress = {};
  getUserDetails() {
    UsersRef = FirebaseDatabase.instance.ref().child("users");
    print(currentFirebaseUser!.uid);
    UsersRef!.child(currentFirebaseUser!.uid).once().then((value) {
      setState(() {
        var vvv = value.snapshot.value;
        print(vvv as Map);
        MailId = (value.snapshot.value as Map)['email'];
        userName = (value.snapshot.value as Map)['FirstName'];
        mobile = (value.snapshot.value as Map)['phone'];
        try {
          address = (value.snapshot.value as Map)['address'];
          address = address["home"];
          homeAddress = address['BuildingName'] +
              ' ,' +
              address['FlatNo'] +
              ', ' +
              address['StreetAddress'] +
              ' ,' +
              address['PostCode'];
        } catch (e) {
          homeAddress = "Click here to add address";
        }
        try {
          ofAddress = (value.snapshot.value as Map)['address']['office'] ?? {};
          officeAddress = ofAddress['BuildingName'] +
              ' ,' +
              ofAddress['FlatNo'] +
              ', ' +
              ofAddress['StreetAddress'] +
              ' ,' +
              ofAddress['PostCode'];
        } catch (e) {
          officeAddress = 'Click here to add address';
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final image = NetworkImage("assets/user.jpg");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Details"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () {
                  _showPicker(context);
                },
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 75,
                      backgroundColor: Colors.grey.shade200,
                      child: GestureDetector(
                        onTap: () {},
                        child: loaded
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.memory(
                                  imageBytes,
                                  fit: BoxFit.fill,
                                ))
                            : const CircleAvatar(
                                radius: 70,
                                backgroundImage: AssetImage('assets/user.jpg'),
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Icon(Icons.add_a_photo,
                              color: Color.fromARGB(255, 106, 106, 106)),
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 3,
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                50,
                              ),
                            ),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(2, 4),
                                color: Colors.black.withOpacity(
                                  0.3,
                                ),
                                blurRadius: 3,
                              ),
                            ]),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                child: Text(
                  userName,
                  style: TextStyle(fontSize: SizeConfig.textMultiplier * 2.4),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mail),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Text(
                      MailId,
                      style: TextStyle(fontSize: SizeConfig.textMultiplier * 2),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Text(
                      mobile,
                      style: TextStyle(fontSize: SizeConfig.textMultiplier * 2),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => EditUserDetails()));
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue)),
                  child: const Text(
                    "Edit Account",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Saved Places :",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: ListTile(
                  tileColor: Color.fromARGB(255, 220, 214, 214),
                  isThreeLine: false,
                  title: Text("Home"),
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => EnterAddress(
                                  type: 'home',
                                  isupdate: address.isEmpty ? false : true,
                                )))
                  },
                  subtitle: Text(
                    homeAddress,
                    overflow: TextOverflow.ellipsis,
                  ),
                  leading: Container(
                    padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                    child: const Icon(Icons.home),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25))),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: ListTile(
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => EnterAddress(
                                type: 'office',
                                isupdate: ofAddress.isEmpty ? false : true)))
                  },
                  tileColor: const Color.fromARGB(255, 220, 214, 214),
                  isThreeLine: false,
                  title: const Text("Office"),
                  subtitle: Text(officeAddress),
                  leading: Container(
                    padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                    child: const Icon(Icons.factory),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25))),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextButton(
              //     onPressed: () {
              //       Navigator.push(context,
              //           MaterialPageRoute(builder: (c) => EnterAddress()));
              //     },
              //     style: ButtonStyle(
              //         backgroundColor: MaterialStateProperty.all(Colors.blue)),
              //     child: const Text(
              //       "Add a new address",
              //       style: TextStyle(color: Colors.white),
              //     ),
              //   ),
              // ),
            ]),
      ),
    );
  }

  String username = 'customerservice@learntounlock.com';
  final smtpServer = SmtpServer('smtp.123-reg.co.uk',
      port: 487,
      username: 'customerservice@learntounlock.com',
      password: '@Learntounlock1',
      ssl: true);
  sendMail() async {
    var connection = PersistentConnection(smtpServer);

    final message = Message()
      ..from = Address(username, 'Icecream')
      ..recipients.add("bharathgowda538@gmail.com")
      ..subject = 'Verification Code'
      ..text = 'This is the Verification code for icecream .';
    // ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

    try {
      final sendReport =
          await send(message, smtpServer, timeout: Duration(seconds: 30));
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print(e);
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
    // print(message);
    // // Send the first message
    // await connection.send(message);

    // // close the connection
    // await connection.close();
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
      getPhoto();
    } catch (e) {
      print('error occured');
    }
  }

  getPhoto() async {
    setState(() {
      loaded = false;
    });

    await storage
        .ref()
        .child('files')
        .child(currentFirebaseUser!.uid)
        .getData(10000000)
        .then((data) => setState(() {
              loaded = true;
              imageBytes = data!;
            }))
        .catchError((e) => setState(() {
              errorMsg = e.error;
            }));
  }
}
