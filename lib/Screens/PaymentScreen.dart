import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:icecream/Screens/AddAddress.dart';
import 'package:icecream/Screens/mapTest.dart';
import 'package:icecream/utils/size_config.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({super.key});

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Method"),
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
                              builder: (context) => AddAddress()));
                    },
                  )),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("How would you like to pay ?",
                    style: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 2.6,
                        fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 3, 10, 15),
                child: Text("You will be charged after the ride",
                    style:
                        TextStyle(fontSize: SizeConfig.textMultiplier * 1.8)),
              ),
              Container(
                height: 10,
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                leading: Icon(Icons.assured_workload_outlined),
                title: Text("Online Banking"),
                subtitle: Text("Link your bank account"),
                trailing: Icon(Icons.arrow_right_sharp),
                tileColor: Color.fromARGB(255, 199, 199, 199),
              ),
              Container(
                height: 10,
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                leading: Icon(Icons.paypal),
                title: Text("PayPal"),
                trailing: Icon(Icons.arrow_right_sharp),
                tileColor: Color.fromARGB(255, 199, 199, 199),
              ),
              Container(
                height: 10,
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                leading: Icon(Icons.credit_card),
                title: Text("Credit or Debit card"),
                trailing: Icon(Icons.arrow_right_sharp),
                tileColor: Color.fromARGB(255, 199, 199, 199),
              )
            ],
          )),
        ),
      ),
    );
  }
}
