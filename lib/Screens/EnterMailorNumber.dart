import 'dart:math';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:icecream/Screens/NumberVerificationScreen.dart';
import 'package:icecream/Screens/VerifyMailorOTP.dart';
import 'package:icecream/authentication/signup_screen.dart';
import 'package:icecream/global/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:icecream/utils/size_config.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:http/http.dart';
//import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:email_validator/email_validator.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:sms_autofill/sms_autofill.dart';

class EnterMailorNumber extends StatefulWidget {
  //const EnterNumber({super.key});
  bool isMail;
  EnterMailorNumber({Key? key, required this.isMail}) : super(key: key);
  @override
  State<EnterMailorNumber> createState() => _EnterMailorNumberState();
}

class _EnterMailorNumberState extends State<EnterMailorNumber> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isEmail(String input) => EmailValidator.validate(input);
  bool isPhone(String input) =>
      RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
          .hasMatch(input);

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  late String _verificationId;
  final SmsAutoFill _autoFill = SmsAutoFill();
  final TextEditingController controller = TextEditingController();
  final TextEditingController newcontroller = TextEditingController();
  String initialCountry = 'IN';
  PhoneNumber number = PhoneNumber(isoCode: 'IN');
  String pno = '';
  String inputValue = '';
  double multiplier = 80;
  String countryCode = '';
  DatabaseReference? driversRef;
  void initState() {
    super.initState();
    setTexts();
  }

  String headerText = '';
  String Secondary = '';
  String hintText = '';
  setTexts() {
    if (widget.isMail) {
      headerText = "Enter your phone number.....";
      Secondary = "We'll text a code to verify your number";
      hintText = "Enter your phone number";
    } else {
      headerText = "Enter your Email Address.....";
      Secondary = "We'll text a code to verify your Email Address";
      hintText = "Enter your Mail Address";
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.isMail);
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome"),
        centerTitle: true,
      ),
      body: Container(
        width: SizeConfig.widthMultiplier * 100,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Center(
                  //   child: Image.asset(
                  //     "images/icecreamtruck.jpg",
                  //     height: 250,
                  //     width: 250,
                  //     alignment: Alignment.center,
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      headerText,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(Secondary, style: TextStyle(fontSize: 14)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.isMail
                          ? CountryCodePicker(
                              onChanged: (value) => {
                                countryCode = value.dialCode!,
                              },
                              initialSelection: 'IN',
                              showCountryOnly: false,
                              showDropDownButton: true,
                              showOnlyCountryWhenClosed: true,
                              hideMainText: true,
                              alignLeft: false,
                              onInit: (value) => {
                                countryCode = value!.dialCode!,
                              },
                            )
                          : Container(),
                      Container(
                        width: SizeConfig.widthMultiplier *
                            (widget.isMail ? 60 : 80),
                        child: TextFormField(
                          validator: (value) {
                            if (!isEmail(value!) && !isPhone(value)) {
                              if (!isEmail(value) && !widget.isMail) {
                                return 'Please enter a valid email .';
                              }
                              if (!isPhone(value)) {
                                return 'Please enter a valid phone number.';
                              }
                            }
                            return null;
                          },
                          controller: newcontroller,
                          onChanged: (value) {
                            inputValue = value;
                            //  validateString(value);
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(16.0),
                            hintText: hintText,
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        disabledElevation: 1,
        onPressed: () {
          //  validateForm();
          sendMail();
          // verifyPhoneNumber();
          // signInWithPhoneNumber();
        },
        tooltip: 'Submit',
        child: const Icon(Icons.chevron_right, size: 40),
      ),
    );
  }

  sendSMS(String pno) async {
    String address = "${dotenv.env['IPADDRESS']}:${dotenv.env['PORT']}";
    print(address);
    String url = "${address}/SMS/sendSMS/" + pno;
    final res = await get(Uri.parse(url));
    if (res.statusCode == 200) {
      final snackBar = SnackBar(
        content: const Text('OTP Sent Successfully...!!'),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(
        content: const Text('Faileddd...!!!'),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      throw "Failed to get Lessons";
    }
  }

  numberOrMail(String num_mail) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(num_mail);
  }

  // validateString(String val) {
  //   if (RegExp(r'^[0-9]+$').hasMatch(val)) {
  //     setState(() {
  //       multiplier = 60;
  //       widget.isMail = false;
  //     });
  //   } else {
  //     setState(() {
  //       multiplier = 80;
  //       widget.isMail = true;
  //     });
  //   }
  // }

  verifyPhoneNumber() async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await fAuth.signInWithCredential(phoneAuthCredential);
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
          phoneNumber: '+917019202723',
          timeout: const Duration(seconds: 5),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to Verify Phone Number: ${e}");
    }
  }

  String username = 'customerservice@learntounlock.com';
  final gsmtp = SmtpServer('smtp.gmail.com',
      port: 465,
      ssl: true,
      name: "LearnToUnlock",
      username: "learntounlockuk@gmail.com",
      password: "Bharath@1",
      allowInsecure: true);
  final smtpServer = SmtpServer('smtp.123-reg.co.uk',
      port: 465,
      username: 'customerservice@learntounlock.com',
      password: '@Learntounlock1',
      ssl: true);
  sendMail() async {
    var rng = Random();
    var code = rng.nextInt(900000) + 100000;
    print(inputValue);
    Map data = {"email": inputValue, "code": code};
    final message = Message()
      ..from = Address(username, 'Icecream')
      ..recipients.add(inputValue)
      ..subject = 'Verification Code'
      ..text = 'This is the Verification code for icecream $code.';
    // ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

    try {
      final sendReport =
          await send(message, gsmtp, timeout: Duration(seconds: 30));
      print('Message sent: ' + sendReport.toString());

      print(data);
      if (!widget.isMail) {
        MailAddress = inputValue;
      } else {
        phoneNumber = countryCode + inputValue;
      }
      driversRef =
          FirebaseDatabase.instance.ref().child("NumberVerification").push();
      driversRef!.set(data);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VerifyNumberorMail(
                number: inputValue,
                isMail: widget.isMail,
                token: driversRef!.key!)),
      );
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

  void signInWithPhoneNumber() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: '+919738602349',
      );

      final User? user = (await fAuth.signInWithCredential(credential)).user;

      Fluttertoast.showToast(msg: "Successfully signed in UID: ${user!.uid}");
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to sign in: " + e.toString());
    }
  }

  validateForm() {
    if (formKey.currentState!.validate()) {
      if (!widget.isMail) {
        MailAddress = inputValue;
      } else {
        phoneNumber = countryCode + inputValue;
      }
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VerifyNumberorMail(
                  number: inputValue,
                  isMail: widget.isMail,
                  token: "tokennn",
                )),
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
