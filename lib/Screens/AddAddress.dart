import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:icecream/Screens/EnterAddress.dart';
import 'package:icecream/Screens/mapTest.dart';
import 'package:icecream/mainScreens/main_screen.dart';
import 'package:icecream/utils/size_config.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({super.key});

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Address Details"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0))),
                        backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 199, 199, 199),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Text(
                        "Skip >>",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainScreen()));
                    },
                  )),
              Center(
                child: Image.asset(
                  "assets/7881.jpg",
                  height: 250,
                  width: SizeConfig.imageSizeMultiplier * 100,
                  alignment: Alignment.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("For faster orders",
                    style: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 2.6,
                        fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 3, 10, 15),
                child: Text(
                    "Enter addresses,streets,postcodes or place names to save your top locations",
                    style:
                        TextStyle(fontSize: SizeConfig.textMultiplier * 1.8)),
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                leading: Icon(Icons.home),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (c) =>
                              EnterAddress(type: 'home', isupdate: false)));
                },
                title: Text("Add Home"),
                trailing: Icon(Icons.arrow_right_sharp),
                tileColor: Color.fromARGB(255, 199, 199, 199),
              ),
              Container(
                height: 10,
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (c) =>
                              EnterAddress(type: 'office', isupdate: false)));
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                leading: Icon(Icons.factory),
                title: Text("Add Work"),
                trailing: Icon(Icons.arrow_right_sharp),
                tileColor: Color.fromARGB(255, 199, 199, 199),
              ),
              Container(
                height: 10,
              ),
            ],
          )),
        ),
      ),
    );
  }
}
