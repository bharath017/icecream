import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:icecream/Screens/AccountSettings.dart';
import 'package:icecream/Screens/ResetPassword.dart';
//import 'package:icecream/Models/User.dart';
import 'package:icecream/Screens/TermsAndConditions.dart';
import 'package:icecream/global/global.dart';
import 'package:icecream/splashScreen/splash_screen.dart';
import 'package:icecream/utils/size_config.dart';
import 'package:icecream/widgets/progress_dialog.dart';

class EditUserDetails extends StatefulWidget {
  const EditUserDetails({Key? key}) : super(key: key);

  @override
  State<EditUserDetails> createState() => _EditUserDetailsState();
}

class _EditUserDetailsState extends State<EditUserDetails> {
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setValue());
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController FirstNameController = TextEditingController();
  TextEditingController LastNameController = TextEditingController();
  TextEditingController EmailController = TextEditingController();
  TextEditingController PhoneController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();

  bool userExists = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Account"),
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
                      width: SizeConfig.widthMultiplier * 55,
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter First Name';
                          }
                          return null;
                        },
                        controller: FirstNameController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'First Name',
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
                      width: SizeConfig.widthMultiplier * 45,
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        controller: LastNameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'Last Name',
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(14),
                        ),
                        obscureText: false,
                        onChanged: (value) {
                          //formData.password = value;
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
                        return 'Please enter Mail Address';
                      }
                      return null;
                    },
                    // initialValue: "MailAddress",
                    controller: EmailController,
                    readOnly: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.mail_outline),
                      fillColor: Color.fromARGB(31, 164, 162, 162),
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      labelText: 'Email Address',
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
                        return 'Please enter Phone Number';
                      }
                      return null;
                    },
                    controller: PhoneController,
                    readOnly: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.call),
                      fillColor: Color.fromARGB(31, 164, 162, 162),
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      labelText: 'Phone Number',
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
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 195, 123, 255)),
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (c) => ResetPassword()));
                      },
                      child: Text(
                        'Reset Password',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                ),
                Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 253, 150, 75)),
                      ),
                      onPressed: () {},
                      child: Text(
                        'UPDATE',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          formKey.currentState!.save();
          if (formKey.currentState!.validate()) {
            // SaveUser(User(
            //   EmailId: EmailController.text,
            //   PhoneNumber: widget.number,
            //   FirstName: FirstNameController.text,
            //   LastName: LastNameController.text,
            // ));
            saveUserInfoNow();
          }
        },
        tooltip: 'Submit',
        child: const Icon(Icons.chevron_right, size: 40),
      ),
    );
  }

  saveUserInfoNow() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(
            message: "Processing, Please wait...",
          );
        });

    Map userMap = {
      "FirstName": FirstNameController.text.trim(),
      "LastName": LastNameController.text.trim(),
    };

    DatabaseReference reference =
        FirebaseDatabase.instance.ref().child("users");
    reference.child(currentFirebaseUser!.uid).set(userMap);

    Fluttertoast.showToast(msg: "Account details has been Updated.");
    Navigator.push(
        context, MaterialPageRoute(builder: (c) => AccountSettings()));
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
      EmailController.text = (value.snapshot.value as Map)['email'];
      PhoneController.text = (value.snapshot.value as Map)['phone'];
      FirstNameController.text = (value.snapshot.value as Map)['FirstName'];
      LastNameController.text = (value.snapshot.value as Map)['LastName'];
      //  PasswordController.text=
    });
  }
}
