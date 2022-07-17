import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icecream/assistants/assistant_methods.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:icecream/global/global.dart';

class SelectNearestActiveDriversScreen extends StatefulWidget {
  DatabaseReference? referenceRideRequest;

  SelectNearestActiveDriversScreen({this.referenceRideRequest});

  @override
  _SelectNearestActiveDriversScreenState createState() =>
      _SelectNearestActiveDriversScreenState();
}

class _SelectNearestActiveDriversScreenState
    extends State<SelectNearestActiveDriversScreen> {
  String fareAmount = "";

  // getFareAmountAccordingToVehicleType(int index)
  // {
  //   if(tripDirectionDetailsInfo != null)
  //   {
  //     if(dList[index]["car_details"]["type"].toString() == "bike")
  //     {
  //       fareAmount = (AssistantMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!) / 2).toStringAsFixed(1);
  //     }
  //     if(dList[index]["car_details"]["type"].toString() == "uber-x") //means executive type of car - more comfortable pro level
  //     {
  //       fareAmount = (AssistantMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!) * 2).toStringAsFixed(1);
  //     }
  //     if(dList[index]["car_details"]["type"].toString() == "uber-go") // non - executive car - comfortable
  //     {
  //       fareAmount = (AssistantMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!)).toString();
  //     }
  //   }
  //   return fareAmount;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white54,
        title: const Text(
          "Nearest Online Drivers",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            //delete/remove the ride request from database

            SystemNavigator.pop();
          },
        ),
      ),
      body: ListView.builder(
        itemCount: dList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Colors.white,
            elevation: 3,
            shadowColor: Colors.green,
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Icon(Icons.car_repair)),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    dList[index]["name"],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    dList[index]["car_details"]["car_model"],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                  SmoothStarRating(
                    rating: 3.5,
                    color: Colors.blue,
                    borderColor: Colors.black,
                    allowHalfRating: true,
                    starCount: 5,
                    size: 15,
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "3",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    "13 km",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                        fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
