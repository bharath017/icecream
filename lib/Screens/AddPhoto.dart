import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:icecream/Screens/PaymentScreen.dart';
import 'package:icecream/global/global.dart';
import 'package:icecream/utils/size_config.dart';

class AddPhoto extends StatefulWidget {
  const AddPhoto({super.key});

  @override
  State<AddPhoto> createState() => _AddPhotoState();
}

class _AddPhotoState extends State<AddPhoto> {
  @override
  Widget build(BuildContext context) {
    final image = NetworkImage("assets/user.jpg");
    return Scaffold(
      body: Column(crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 80,
            ),
            Container(
              alignment: Alignment.center,
              child: ClipOval(
                child: Material(
                  color: Colors.transparent,
                  child: Image.asset(
                    "assets/user.jpg",
                    alignment: Alignment.center,
                    height: 200,
                    width: 200,
                  ),
                ),
              ),
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
            Container(
              color: Colors.white,
              width: SizeConfig.widthMultiplier * 60,
              height: 50,
              child: TextButton(
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 71, 207, 252)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            side: BorderSide(
                                color: Color.fromARGB(255, 71, 207, 252))))),
                onPressed: () {},
                child: Text(
                  "Take Photo",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Raleway',
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.transparent,
              width: SizeConfig.widthMultiplier * 60,
              height: 50,
              child: TextButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            side: BorderSide(
                                color: Color.fromARGB(255, 71, 207, 252))))),
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
            ),
            SizedBox(
              height: 30,
            ),
          ]),
    );
  }
}
