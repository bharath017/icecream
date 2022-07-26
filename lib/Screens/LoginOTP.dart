import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icecream/Screens/EnterMailorNumber.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:icecream/Screens/NumberScreen.dart';
import 'package:icecream/global/global.dart';
import 'package:icecream/mainScreens/main_screen.dart';
//import 'package:icecream/Screens/UserDetailsScreen.dart';
import 'package:icecream/utils/size_config.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:sms_autofill/sms_autofill.dart';

class LoginOTP extends StatefulWidget {
  String number;
  bool isMail;
  String? token;

  LoginOTP(
      {Key? key,
      required this.number,
      required this.isMail,
      required this.token})
      : super(key: key);

  @override
  State<LoginOTP> createState() => _LoginOTPState();
}

class _LoginOTPState extends State<LoginOTP> {
  String _code = "";
  int OTP = 0;
  bool isValid = true;
  String signature = "{{ app signature }}";
  DatabaseReference? driversRef;

  String _verificationId = '';
  void initState() {
    super.initState();
    verifyPhoneNumber();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.isMail);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Welcome"),
      ),
      body: SingleChildScrollView(
        child: Column(
            verticalDirection: VerticalDirection.down,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(
                  image: const AssetImage("assets/otp-security.png"),
                  height: SizeConfig.imageSizeMultiplier > 8
                      ? SizeConfig.imageSizeMultiplier * 40
                      : SizeConfig.imageSizeMultiplier * 80,
                  alignment: Alignment.center),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "What's the code ?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Enter the code sent to ${widget.number}",
                    style: const TextStyle(fontSize: 14)),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                child: PinFieldAutoFill(
                  decoration: UnderlineDecoration(
                    errorText: isValid ? null : "Invalid Code",
                    errorTextStyle: const TextStyle(
                        height: 0.1,
                        fontSize: 14,
                        leadingDistribution: TextLeadingDistribution.even,
                        decorationColor: Colors.red,
                        color: Colors.red,
                        debugLabel: "Invlid Code.....!!",
                        overflow: TextOverflow.ellipsis),
                    textStyle: const TextStyle(
                        fontSize: 20, color: Color.fromARGB(255, 0, 0, 0)),
                    colorBuilder: FixedColorBuilder(
                        Color.fromARGB(255, 88, 88, 88).withOpacity(0.3)),
                  ),
                  currentCode: _code,
                  onCodeSubmitted: (code) {},
                  onCodeChanged: (code) {
                    if (code!.length == 6) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      setOtp(code);
                    }
                  },
                ),
              ),
              Center(
                  child: TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.blue,
                ),
                child: const Text(
                  'Resend OTP ?',
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  sendSMS(widget.number);
                },
              ))
            ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // verifyOTP(widget.number, OTP);
          signInWithPhoneNumber();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.chevron_right, size: 40),
      ),
    );
  }

  setOtp(String Otp) {
    print("RECEIVED ${Otp}");
    OTP = int.parse(Otp);
  }

  verifyPhoneNumber() async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      // await fAuth.signInWithCredential(phoneAuthCredential);
      print("Verified");

      Fluttertoast.showToast(
          msg:
              "Phone number automatically verified and user signed in: ${fAuth.currentUser!.uid}");
    };
    PhoneCodeSent codeSent =
        (String verificationId, int? forceResendingToken) async {
      print("code sent");

      // showSnackbar('Please check your phone for the verification code.');
      _verificationId = verificationId;
      print(_verificationId);
    };
    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      print("Verification failed");
      print(authException.message);
      Fluttertoast.showToast(
        timeInSecForIosWeb: 10,
        msg:
            'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}',
      );
      // showSnackbar('Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
    };
    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      Fluttertoast.showToast(msg: "verification code: " + verificationId);
      _verificationId = verificationId;
    };
    try {
      await fAuth.verifyPhoneNumber(
          phoneNumber: widget.number,
          //timeout: const Duration(seconds: 5),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Failed to Verify Phone Number: ${e}");
    }
  }

  void signInWithPhoneNumber() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: OTP.toString(),
      );

      final User? user = (await fAuth.signInWithCredential(credential)).user;
      currentFirebaseUser = user;
      // await user!.linkWithCredential(credential);
      // print(user.phoneNumber);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
      Fluttertoast.showToast(msg: "Successfully signed in UID: ${user!.uid}");
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to sign in: " + e.toString());
    }
  }

  sendSMS(String number) {}

  verifyOTP(String pno, int OTP) async {
    driversRef = FirebaseDatabase.instance.ref().child("NumberVerification");
    driversRef!.child(widget.token!).once().then((value) {
      if ((value.snapshot.value as Map)['number'] == widget.number &&
          (value.snapshot.value as Map)['code'] == OTP) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EnterMailorNumber(
                    isMail: widget.isMail,
                  )),
        );
      } else {
        setState(() {
          isValid = false;
        });
        final snackBar = SnackBar(
          content: const Text('Faileddd...!!!'),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }
}
