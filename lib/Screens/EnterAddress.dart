import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
//import 'package:icecream/Models/User.dart';
import 'package:icecream/Screens/TermsAndConditions.dart';
import 'package:icecream/global/global.dart';
import 'package:icecream/splashScreen/splash_screen.dart';
import 'package:icecream/utils/size_config.dart';
import 'package:icecream/widgets/progress_dialog.dart';

class EnterAddress extends StatefulWidget {
  String type;
  bool isupdate;
  EnterAddress({Key? key, required this.type, required this.isupdate})
      : super(key: key);

  @override
  State<EnterAddress> createState() => _EnterAddressState();
}

class _EnterAddressState extends State<EnterAddress> {
  void initState() {
    super.initState();
    print(widget.type);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => {widget.isupdate ? setValue() : ''});
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController BuildingNameController = TextEditingController();
  TextEditingController FlatNumberController = TextEditingController();
  TextEditingController StreetNameController = TextEditingController();
  TextEditingController PostCodeController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();

  bool userExists = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Address"),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: SizeConfig.widthMultiplier * 100,
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Door No.';
                          }
                          return null;
                        },
                        controller: BuildingNameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'Door No.',
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(14),
                        ),
                        obscureText: false,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            // formKey.currentState!.validate();
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  width: SizeConfig.widthMultiplier * 100,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Flat/House No.';
                      }
                      return null;
                    },
                    // initialValue: "MailAddress",
                    controller: FlatNumberController,
                    readOnly: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      labelText: 'Flat/House No.',
                      isDense: true, // Added this
                      contentPadding: EdgeInsets.all(14),
                    ),
                    obscureText: false,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        // formKey.currentState!.validate();
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  width: SizeConfig.widthMultiplier * 100,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Street address';
                      }
                      return null;
                    },
                    controller: StreetNameController,
                    readOnly: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      labelText: 'Street address',
                      isDense: true, // Added this
                      contentPadding: EdgeInsets.all(14),
                    ),
                    obscureText: false,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        // formKey.currentState!.validate();
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  width: SizeConfig.widthMultiplier * 100,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter POSTCODE';
                      }
                      return null;
                    },
                    controller: PostCodeController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      labelText: 'POSTCODE',
                      isDense: true, // Added this
                      contentPadding: EdgeInsets.all(14),
                    ),
                    obscureText: false,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        // formKey.currentState!.validate();
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 253, 150, 75)),
                      ),
                      onPressed: () {
                        saveUserAddress();
                      },
                      child: Text(
                        widget.isupdate ? 'Update' : 'Add',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  saveUserAddress() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(
            message: "Processing, Please wait...",
          );
        });

    Map userMap = {
      "BuildingName": BuildingNameController.text.trim(),
      "FlatNo": FlatNumberController.text.trim(),
      "StreetAddress": StreetNameController.text.trim(),
      "PostCode": PostCodeController.text.trim(),
    };

    DatabaseReference reference = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(currentFirebaseUser!.uid);
    reference.child('address').child(widget.type).set(userMap);
    Navigator.pop(context);
    Fluttertoast.showToast(msg: "Address added Successfully.");
  }

  // SaveUser(User user) async {
  //   Map data = {
  //     'EmailAddress': user.EmailId,
  //     'FirstName': user.FirstName,
  //     'LastName': user.LastName,
  //     'PhoneNumber': user.PhoneNumber
  //   };
  //   print(jsonEncode(data));
  //   final response = await post(
  //     Uri.parse('http://192.168.0.105:5000/User/addUser'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(data),
  //   );
  //   var result = jsonDecode(response.body);
  //   print(result);
  //   if (response.statusCode == 200) {
  //     final snackBar = SnackBar(
  //       content: const Text('User details saved Successfully'),
  //       action: SnackBarAction(
  //         label: 'Close',
  //         onPressed: () {
  //           // Some code to undo the change.
  //         },
  //       ),
  //     );

  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) =>
  //                 TermsAndConditions(UserId: result['UserId'])));
  //   } else {
  //     final snackBar = SnackBar(
  //       content: const Text('Email address exists.'),
  //       action: SnackBarAction(
  //         label: 'Close',
  //         onPressed: () {
  //           // Some code to undo the change.
  //         },
  //       ),
  //     );
  //     setState(() {
  //       userExists = true;
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //     throw Exception('Failed to load album');
  //   }
  // }
  DatabaseReference? driversRef;
  setValue() {
    driversRef = FirebaseDatabase.instance.ref().child("users");
    driversRef!.child(currentFirebaseUser!.uid).once().then((value) {
      var address = (value.snapshot.value as Map)['address'][widget.type] ?? {};
      BuildingNameController.text = address['BuildingName'];
      FlatNumberController.text = address['FlatNo'];
      PostCodeController.text = address['PostCode'];
      StreetNameController.text = address['StreetAddress'];
    });
  }
}
