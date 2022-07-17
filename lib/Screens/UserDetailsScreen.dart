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

class UserDetails extends StatefulWidget {
  final String number;
  const UserDetails({Key? key, required this.number}) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
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
        title: Text("About you"),
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
                Image(
                    image: const AssetImage("assets/PD1.png"),
                    height: SizeConfig.imageSizeMultiplier > 8
                        ? SizeConfig.imageSizeMultiplier * 35
                        : SizeConfig.imageSizeMultiplier * 70),
                const Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Tell us about yourself....!!",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
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
                      fillColor: Color.fromARGB(255, 234, 233, 229),
                      filled: true,
                      suffixIcon:
                          Icon(Icons.verified_outlined, color: Colors.green),
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
                      fillColor: Color.fromARGB(255, 234, 233, 229),
                      filled: true,
                      prefixIcon: Icon(Icons.call),
                      suffixIcon:
                          Icon(Icons.verified_outlined, color: Colors.green),
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
                  width: SizeConfig.widthMultiplier * 100,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Phone Number';
                      }
                      return null;
                    },
                    controller: PasswordController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.password),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      labelText: 'Password',
                      isDense: true, // Added this
                      contentPadding: EdgeInsets.all(14),
                    ),
                    obscureText: true,
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

    final User? firebaseUser = (await fAuth
            .createUserWithEmailAndPassword(
      email: EmailController.text.trim(),
      password: PasswordController.text.trim(),
    )
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error: " + msg.toString());
    }))
        .user;

    if (firebaseUser != null) {
      Map userMap = {
        "id": firebaseUser.uid,
        "FirstName": FirstNameController.text.trim(),
        "LastName": LastNameController.text.trim(),
        "email": EmailController.text.trim(),
        "phone": PhoneController.text.trim(),
      };

      DatabaseReference reference =
          FirebaseDatabase.instance.ref().child("users");
      reference.child(firebaseUser.uid).set(userMap);

      currentFirebaseUser = firebaseUser;
      Fluttertoast.showToast(msg: "Account has been Created.");
      Navigator.push(
          context, MaterialPageRoute(builder: (c) => TermsAndConditions()));
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Account has not been Created.");
    }
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

  setValue() {
    EmailController.text = MailAddress;
    PhoneController.text = phoneNumber;
  }
}
