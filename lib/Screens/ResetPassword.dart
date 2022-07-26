import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icecream/Screens/AccountSettings.dart';
import 'package:icecream/global/global.dart';
import 'package:icecream/utils/size_config.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController OldPasswordController = TextEditingController();
  TextEditingController NewPasswordController = TextEditingController();
  TextEditingController VerifyPasswordController = TextEditingController();

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
                            return 'Please enter Your old password.';
                          }
                          return null;
                        },
                        controller: OldPasswordController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'Old Password',
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
                Container(
                  padding: EdgeInsets.all(10),
                  width: SizeConfig.widthMultiplier * 100,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter New Password.';
                      }
                      return null;
                    },
                    // initialValue: "MailAddress",
                    controller: NewPasswordController,
                    readOnly: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      labelText: 'New Password',
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
                Container(
                  padding: EdgeInsets.all(10),
                  width: SizeConfig.widthMultiplier * 100,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Confirm Password';
                      }
                      return null;
                    },
                    controller: VerifyPasswordController,
                    readOnly: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      labelText: 'Confirm Password',
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
                Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 253, 150, 75)),
                      ),
                      onPressed: () {
                        updatePassword();
                      },
                      child: Text(
                        "Update Passowrd",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
    ;
  }

  Future<bool> login(String email, String password) async {
    User? user = (await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password))
        .user;
    if (user != null) {
      print("Verified");
      return true;
    }
    return false;
  }

  updatePassword() async {
    formKey.currentState!.save();
    if (formKey.currentState!.validate()) {
      String oldPassword = OldPasswordController.text.trim();
      String newPassword = NewPasswordController.text.trim();
      String confirmPassword = VerifyPasswordController.text.trim();
      if (newPassword != confirmPassword) {
        Fluttertoast.showToast(msg: "New passwords do not match");
        VerifyPasswordController.clear();
      } else {
        try {
          User? user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: currentFirebaseUser!.email!, password: oldPassword))
              .user;
          if (user != null) {
            await currentFirebaseUser!.updatePassword(newPassword);
            Fluttertoast.showToast(msg: "Password Changed Successfully");
            Navigator.push(
                context, MaterialPageRoute(builder: (c) => AccountSettings()));
          } else {
            Fluttertoast.showToast(msg: "Wrong Password");
            OldPasswordController.clear();
          }
        } catch (e) {
          Fluttertoast.showToast(msg: "Wrong Password");
          OldPasswordController.clear();
        }
      }
    }
  }
}
