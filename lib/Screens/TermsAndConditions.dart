import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart';
import 'package:icecream/Screens/AddPhoto.dart';
import 'package:icecream/Screens/PaymentScreen.dart';
import 'package:icecream/utils/size_config.dart';

class TermsAndConditions extends StatefulWidget {
  //final int UserId;

  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  String data = '';
  bool value = false;
  bool isChecked = false;

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.blue;
  }

  fetchFileData() async {
    String responseText;
    responseText = await rootBundle.loadString('assets/TC.txt');

    setState(() {
      data = responseText;
    });
  }

  void initState() {
    fetchFileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Terms and Conditions"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('Our Terms and Conditions',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: SizeConfig.textMultiplier * 3)),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: SizeConfig.widthMultiplier * 100,
                    child: Text("${data}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: SizeConfig.textMultiplier * 2)),
                  ),
                ),
                // Container(
                //     color: Colors.white,
                //     child: Row(
                //       children: [
                //         Checkbox(
                //           checkColor: Colors.white,
                //           fillColor:
                //               MaterialStateProperty.resolveWith(getColor),
                //           value: isChecked,
                //           onChanged: (bool? value) {
                //             setState(() {
                //               isChecked = value!;
                //             });
                //           },
                //         ),
                //         const Flexible(
                //           child: Text(
                //             "I have read the terms and conditions and agree to the same",
                //             style: TextStyle(color: Colors.black, fontSize: 18),
                //           ),
                //         ),
                //       ],
                //     )),
                Container(
                  height: 30,
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Container(
          height: 80,
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddPhoto()),
                );
                //agree();
              },
              child: const Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Text(
                  "I agree",
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  agree() async {
    final res = await get(
      Uri.parse('http://192.168.0.105:5000/User/acceptTC/1'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var result = jsonDecode(res.body);
    if (res.statusCode == 200) {
      if (jsonDecode(res.body) == true) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PaymentMethod()),
        );
        final snackBar = SnackBar(
          content: const Text('You accepted our terms and conditions...!!'),
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
      }
    } else {
      final snackBar = SnackBar(
        content: const Text('Faileddd...!!!'),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      throw "Failed to Verify conditions";
    }
  }
}
