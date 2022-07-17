import 'dart:convert';

import 'package:icecream/Screens/EnterMailorNumber.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:icecream/Screens/NumberScreen.dart';
import 'package:icecream/Screens/UserDetailsScreen.dart';
//import 'package:drivers_app/Screens/UserDetailsScreen.dart';
import 'package:icecream/utils/size_config.dart';
import 'package:sms_autofill/sms_autofill.dart';

class VerifyNumberorMail extends StatefulWidget {
  String number;
  bool isMail;

  VerifyNumberorMail({Key? key, required this.number, required this.isMail})
      : super(key: key);

  @override
  State<VerifyNumberorMail> createState() => _VerifyNumberState();
}

class _VerifyNumberState extends State<VerifyNumberorMail> {
  String _code = "";
  int OTP = 0;
  bool isValid = true;
  String signature = "{{ app signature }}";
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
          verifyOTP(widget.number, OTP);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UserDetails(
                      number: widget.number,
                    )),
          );
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

  sendSMS(String pno) async {
    String address = "${DotEnv().env['IPADDRESS']}:${DotEnv().env['PORT']}";
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

  verifyOTP(String pno, int OTP) async {
    String url =
        "http://192.168.0.105:5000/SMS/verifyOTP?PhoneNumber=${pno}&OTP=${OTP}";
    final res = await post(Uri.parse(url));
    if (res.statusCode == 200) {
      if (jsonDecode(res.body) == true) {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => UserDetails(number: pno)),
        // );
        final snackBar = SnackBar(
          content: const Text('OTP Verified Successfully...!!'),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
    } else {
      final snackBar = SnackBar(
        content: const Text('Faileddd...!!!'),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        ),
      );
      setState(() {
        isValid = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      throw "Failed to Verify OTP";
    }
  }
}
