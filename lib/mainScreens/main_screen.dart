import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:icecream/Screens/AccountSettings.dart';
import 'package:icecream/assistants/assistant_methods.dart';
import 'package:icecream/assistants/geofire_assistant.dart';
import 'package:icecream/infoHandler/app_info.dart';
import 'package:icecream/mainScreens/search_places_screen.dart';
import 'package:icecream/mainScreens/select_nearest_active_driver_screen.dart';
import 'package:icecream/models/active_nearby_available_drivers.dart';
import 'package:icecream/push_notifications/push_notification_system.dart';
import 'package:icecream/utils/size_config.dart';
import 'package:icecream/widgets/my_drawer.dart';
import 'package:icecream/widgets/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:icecream/assistants/assistant_methods.dart';
import 'package:icecream/assistants/geofire_assistant.dart';
import 'package:icecream/authentication/login_screen.dart';
import 'package:icecream/global/global.dart';
import 'package:icecream/infoHandler/app_info.dart';
import 'package:icecream/main.dart';
import 'package:icecream/widgets/progress_dialog.dart';
import 'package:geocoding/geocoding.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:ui' as ui;

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  double searchLocationContainerHeight = 250;
  double waitingResponseFromDriverContainerHeight = 0;
  double assignedDriverInfoContainerHeight = 0;

  Position? userCurrentPosition;
  var geoLocator = Geolocator();
  TextEditingController PostCodeController = TextEditingController();

  LocationPermission? _locationPermission;
  double bottomPaddingOfMap = 0;

  List<LatLng> pLineCoOrdinatesList = [];
  Set<Polyline> polyLineSet = {};

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  String userName = "your Name";
  String userEmail = "your Email";

  final radius = BehaviorSubject<double>.seeded(1.0);
  late Stream<List<DocumentSnapshot>> stream;

  bool openNavigationDrawer = true;

  bool activeNearbyDriverKeysLoaded = false;
  BitmapDescriptor? activeNearbyIcon;
  DatabaseReference? referenceRideRequest;
  String driverRideStatus = "Driver is Coming";
  StreamSubscription<DatabaseEvent>? tripRideRequestInfoStreamSubscription;
  String postCode = '';
  String userRideRequestStatus = "";
  bool requestPositionInfo = true;
  List<ActiveNearbyAvailableDrivers> onlineNearByAvailableDriversList = [];
  String originAddress = '';
  blackThemeGoogleMap() {
    newGoogleMapController!.setMapStyle('''
                    [
                      {
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "featureType": "administrative.locality",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#263c3f"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#6b9a76"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#38414e"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#212a37"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#9ca5b3"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#1f2835"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#f3d19c"
                          }
                        ]
                      },
                      {
                        "featureType": "transit",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#2f3948"
                          }
                        ]
                      },
                      {
                        "featureType": "transit.station",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#515c6d"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      }
                    ]
                ''');
  }

  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition =
        LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress =
        await AssistantMethods.searchAddressForGeographicCoOrdinates(
            userCurrentPosition!, context);
    print("this is your address = " + humanReadableAddress);

    userName = userModelCurrentInfo!.name!;
    userEmail = userModelCurrentInfo!.email!;

    // initializeGeoFireListener();
  }

  @override
  void initState() {
    super.initState();

    checkIfLocationPermissionAllowed();
    PushNotificationSystem pushNotificationSystem = PushNotificationSystem();
    // pushNotificationSystem.initializeCloudMessaging(context);
    pushNotificationSystem.generateAndGetToken();
  }

  saveRideRequestInformation() {
    //1. save the RideRequest Information
    referenceRideRequest =
        FirebaseDatabase.instance.ref().child("All Ride Requests").push();

    var originLocation =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;

    Map originLocationMap = {
      //"key": value,
      "latitude": originLocation!.locationLatitude.toString(),
      "longitude": originLocation!.locationLongitude.toString(),
    };

    Map userInformationMap = {
      "origin": originLocationMap,
      "time": DateTime.now().toString(),
      "userName": userModelCurrentInfo!.name,
      "userPhone": userModelCurrentInfo!.phone,
      "originAddress": originLocation.locationName,
      "driverId": "waiting",
      "userId": userModelCurrentInfo!.id,
      "status": "idle"
    };

    originAddress = originLocation.locationName!;
    referenceRideRequest!.set(userInformationMap);

    tripRideRequestInfoStreamSubscription =
        referenceRideRequest!.onValue.listen((eventSnap) {
      if (eventSnap.snapshot.value == null) {
        return;
      }

      if ((eventSnap.snapshot.value as Map)["driverPhone"] != null) {
        setState(() {
          driverPhone =
              (eventSnap.snapshot.value as Map)["driverPhone"].toString();
        });
      }

      if ((eventSnap.snapshot.value as Map)["driverName"] != null) {
        setState(() {
          driverName =
              (eventSnap.snapshot.value as Map)["driverName"].toString();
        });
      }

      if ((eventSnap.snapshot.value as Map)["status"] != null) {
        print("inside status");
        userRideRequestStatus =
            (eventSnap.snapshot.value as Map)["status"].toString();
        print("Status===" + userRideRequestStatus);

        if (userRideRequestStatus == "accepted") {
          print(userRideRequestStatus == "accepted");

          print("toasting");
          Fluttertoast.showToast(
              msg:
                  "The driver has Confirmed your order. Please Wait for his arrival.....");
          print("Toasted");
          // updateArrivalTimeToUserPickupLocation(driverCurrentPositionLatLng);
        }
      }

      if ((eventSnap.snapshot.value as Map)["driverLocation"] != null) {
        double driverCurrentPositionLat = double.parse(
            (eventSnap.snapshot.value as Map)["driverLocation"]["latitude"]
                .toString());
        double driverCurrentPositionLng = double.parse(
            (eventSnap.snapshot.value as Map)["driverLocation"]["longitude"]
                .toString());

        LatLng driverCurrentPositionLatLng =
            LatLng(driverCurrentPositionLat, driverCurrentPositionLng);

        //status = accepted

        if (userRideRequestStatus == "accepted") {
          showUIForAssignedDriverInfo();
          updateArrivalTimeToUserPickupLocation(driverCurrentPositionLatLng);
          Fluttertoast.showToast(
              msg:
                  "The driver has Confirmed your order. Please Wait for his arrival.....");
        }

        //status = arrived
        if (userRideRequestStatus == "arrived") {
          print("arrived");
          setState(() {
            driverRideStatus = "Driver has Arrived";
          });
        }

        ////status = ontrip
        if (userRideRequestStatus == "ontrip") {
          //  updateReachingTimeToUserDropOffLocation(driverCurrentPositionLatLng);
        }
      }

      if (userRideRequestStatus == "accepted") {
        Fluttertoast.showToast(
            msg:
                "The driver has Confirmed your order. Please Wait for his arrival.....");
        // updateArrivalTimeToUserPickupLocation(driverCurrentPositionLatLng);
      }
    });

    for (ActiveNearbyAvailableDrivers eachDriver
        in GeoFireAssistant.activeNearbyAvailableDriversList) {
      sendNotificationToDriverNow(eachDriver.driverId!);
    }
    onlineNearByAvailableDriversList =
        GeoFireAssistant.activeNearbyAvailableDriversList;
    // searchNearestOnlineDrivers();
  }

  sendNotificationToDriverNow(String chosenDriverId) {
    //assign/SET rideRequestId to newRideStatus in
    // Drivers Parent node for that specific choosen driver
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(chosenDriverId)
        .child("newRideStatus")
        .set(referenceRideRequest!.key);

    //automate the push notification service
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(chosenDriverId)
        .child("token")
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        String deviceRegistrationToken = snap.snapshot.value.toString();

        //send Notification Now
        AssistantMethods.sendNotificationToDriverNow(
          deviceRegistrationToken,
          referenceRideRequest!.key.toString(),
          context,
        );

        Fluttertoast.showToast(msg: "Notification sent Successfully.");
      } else {
        Fluttertoast.showToast(msg: "Please choose another driver.");
        return;
      }
    });
  }

  updateArrivalTimeToUserPickupLocation(driverCurrentPositionLatLng) async {
    if (requestPositionInfo == true) {
      requestPositionInfo = false;

      LatLng userPickUpPosition =
          LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

      var directionDetailsInfo =
          await AssistantMethods.obtainOriginToDestinationDirectionDetails(
        driverCurrentPositionLatLng,
        userPickUpPosition,
      );
      await drawPolyLineFromOriginToDestination(
          driverCurrentPositionLatLng, userPickUpPosition);
      if (directionDetailsInfo == null) {
        return;
      }

      setState(() {
        driverRideStatus = "Driver is Coming :: " +
            directionDetailsInfo.duration_text.toString();
      });

      requestPositionInfo = true;
    }
  }

  showUIForAssignedDriverInfo() {
    // Navigator.pop(context);
    setState(() {
      waitingResponseFromDriverContainerHeight = 0;
      searchLocationContainerHeight = 0;
      assignedDriverInfoContainerHeight = 240;
    });
  }

  showEnterPostalCode() {
    setState(() {
      searchLocationContainerHeight = 0;
      waitingResponseFromDriverContainerHeight = 220;
    });
  }

  searchNearestOnlineDrivers() async {
    //no active driver available
    if (onlineNearByAvailableDriversList.length == 0) {
      //cancel/delete the RideRequest Information
      referenceRideRequest!.remove();

      setState(() {
        polyLineSet.clear();
        // markersSet.clear();
        markersSet.removeWhere(
            (element) => element.markerId != const MarkerId("userMarker"));

        circlesSet.clear();
        pLineCoOrdinatesList.clear();
      });

      Fluttertoast.showToast(
          msg:
              "No Online Nearest Driver Available. Search Again after some time, Restarting App Now.");

      Future.delayed(const Duration(milliseconds: 4000), () {
        SystemNavigator.pop();
      });

      return;
    }

    //active driver available
    await retrieveOnlineDriversInformation(onlineNearByAvailableDriversList);
    print(dList);
    dList.forEach((value) => {
          sendNotificationToDriverNow(value["id"])
          //dList[index]["id"].toString()
        });
  }

  retrieveOnlineDriversInformation(List onlineNearestDriversList) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child("drivers");
    for (int i = 0; i < onlineNearestDriversList.length; i++) {
      await ref
          .child(onlineNearestDriversList[i].driverId.toString())
          .once()
          .then((dataSnapshot) {
        print(onlineNearestDriversList[i].driverId.toString());
        var driverKeyInfo = dataSnapshot.snapshot.value;
        dList.add(driverKeyInfo);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    createActiveNearByDriverIconMarker();

    return Scaffold(
      key: sKey,
      drawer: Container(
        width: 265,
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.black,
          ),
          child: MyDrawer(
            name: userName,
            email: userEmail,
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            initialCameraPosition: _kGooglePlex,
            polylines: polyLineSet,
            markers: markersSet,
            tiltGesturesEnabled: false,
            onCameraMove: (CameraPosition cameraPosition) {
              print(cameraPosition.zoom);
            },
            circles: circlesSet,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              //for black theme google map
              blackThemeGoogleMap();

              setState(() {
                bottomPaddingOfMap = 240;
              });

              locateUserPosition();
            },
          ),
          Positioned(
              top: 50,
              right: 20,
              child: FloatingActionButton(
                child: Icon(Icons.person, size: 30),
                backgroundColor: Colors.grey,
                heroTag: 1,
                onPressed: () {
                  //do something on press
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => AccountSettings()));
                },
              )),
          //custom hamburger button for drawer
          Positioned(
            top: 30,
            left: 14,
            child: GestureDetector(
              onTap: () {
                if (openNavigationDrawer) {
                  sKey.currentState!.openDrawer();
                } else {
                  //restart-refresh-minimize app progmatically
                  SystemNavigator.pop();
                }
              },
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(
                  openNavigationDrawer ? Icons.menu : Icons.close,
                  color: Colors.black54,
                ),
              ),
            ),
          ),

          //ui for searching location
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedSize(
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 120),
              child: Container(
                height: searchLocationContainerHeight,
                decoration: const BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: !callOptions
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 18),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              child: const Text(
                                "Call Ice Cream Van",
                              ),
                              onPressed: () {
                                setState(() {
                                  callOptions = true;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(255, 99, 221, 217),
                                  textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 18),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.topRight,
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    callOptions = false;
                                  });
                                },
                                child: const CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.grey,
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(10, 30, 10, 30),
                              child: Text(
                                  "Choose where you want the icecream van to come....",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  child: const Text(
                                    "Home postcode",
                                  ),
                                  onPressed: () {
                                    showEnterPostalCode();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.green,
                                      textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ),
                                ElevatedButton(
                                  child: const Text(
                                    "Current Location",
                                  ),
                                  onPressed: () {
                                    callDrivers();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.green,
                                      textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: waitingResponseFromDriverContainerHeight,
              decoration: const BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Center(
                    child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                              child: Text("Enter your post code",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  callOptions = false;
                                });
                              },
                              child: const CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.grey,
                                child: Icon(
                                  Icons.close,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      TextField(
                        cursorHeight: 18,
                        cursorColor: Colors.white,
                        controller: PostCodeController,
                        decoration: InputDecoration(
                          fillColor: Color.fromARGB(255, 105, 100, 100),
                          filled: true,

                          floatingLabelStyle: TextStyle(
                            color: Colors.white,
                            backgroundColor: Colors.black,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 0.0),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 0.0),
                          ),

                          labelText: 'Postcode',
                          labelStyle: TextStyle(color: Colors.white),
                          hintText: "Enter your postcode",
                          focusColor: Colors.white,
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(14),
                        ),
                        obscureText: false,
                        onChanged: (value) {
                          postCode = value;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            child: const Text(
                              "Search",
                            ),
                            onPressed: () {
                              getLatLang(postCode);
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                textStyle: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
              ),
            ),
          ),

          //ui for displaying assigned driver information
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: assignedDriverInfoContainerHeight,
              decoration: const BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //status of ride
                    Center(
                      child: Text(
                        driverRideStatus,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white54,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 20.0,
                    ),

                    const Divider(
                      height: 2,
                      thickness: 2,
                      color: Colors.white54,
                    ),

                    const SizedBox(
                      height: 20.0,
                    ),

                    //driver vehicle details
                    Text(
                      driverCarDetails,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white54,
                      ),
                    ),

                    const SizedBox(
                      height: 2.0,
                    ),

                    //driver name
                    Text(
                      driverName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white54,
                      ),
                    ),

                    const SizedBox(
                      height: 20.0,
                    ),

                    const Divider(
                      height: 2,
                      thickness: 2,
                      color: Colors.white54,
                    ),

                    const SizedBox(
                      height: 20.0,
                    ),

                    //call driver button
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                        ),
                        icon: const Icon(
                          Icons.phone_android,
                          color: Colors.black54,
                          size: 22,
                        ),
                        label: const Text(
                          "Call Driver",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool callOptions = false;

  getLatLang(String postCode) async {
    List<Location> locations =
        await locationFromAddress(postCode, localeIdentifier: "en_GB");
    print(locations);
    if (locations.length > 0) {
      LatLng userLatLng = LatLng(locations[0].latitude, locations[0].longitude);
      CameraPosition cameraPosition =
          CameraPosition(target: userLatLng, zoom: 14 - (userRadius / 3));

      newGoogleMapController!
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

      Marker pincodeMarker = Marker(
        markerId: const MarkerId("userMarker"),
        infoWindow: InfoWindow(title: "Stringgg", snippet: "Destination"),
        position: userLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
      );
      setState(() {
        markersSet.add(pincodeMarker);
      });
      Position userPosition = Position(
          longitude: userLatLng.longitude,
          latitude: userLatLng.latitude,
          timestamp: DateTime.now(),
          accuracy: 5.0,
          altitude: 0,
          heading: -1.0,
          speed: -1.0,
          speedAccuracy: -1.0);
      userCurrentPosition = userPosition;
      //  initializeGeoFireListener();
      circlesSet.clear();
    } else {
      Fluttertoast.showToast(
        msg: "No place found. Please enter Valid POST CODE....",
      );
    }
  }

  callDrivers() async {
    saveRideRequestInformation();
    // showWaitingResponseFromDriverUI();
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      backgroundColor: Color.fromARGB(255, 250, 250, 249),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
          height: 250,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const <Widget>[
                Image(
                    image: AssetImage("assets/truck.png"),
                    height: 100,
                    width: 120),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                  child: Text('Requested..... waiting for drivers to respond',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  double _value = 0.5;
  String _label = '';

  double userRadius = 1.6;
  bool closed = false;
  Future<void> drawPolyLineFromOriginToDestination(
      LatLng driverLocation, LatLng userLocation) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: "Please wait...",
      ),
    );

    var directionDetailsInfo =
        await AssistantMethods.obtainOriginToDestinationDirectionDetails(
            driverLocation, userLocation);

    Navigator.pop(context);
    Navigator.pop(context);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResultList =
        pPoints.decodePolyline(directionDetailsInfo!.e_points!);

    pLineCoOrdinatesList.clear();

    if (decodedPolyLinePointsResultList.isNotEmpty) {
      decodedPolyLinePointsResultList.forEach((PointLatLng pointLatLng) {
        pLineCoOrdinatesList
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polyLineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
          color: Colors.purpleAccent,
          polylineId: const PolylineId("PolylineID"),
          jointType: JointType.round,
          points: pLineCoOrdinatesList,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true,
          width: 5);

      polyLineSet.add(polyline);
    });

    LatLngBounds boundsLatLng;
    if (driverLocation.latitude > userLocation.latitude &&
        driverLocation.longitude > userLocation.longitude) {
      boundsLatLng =
          LatLngBounds(southwest: userLocation, northeast: driverLocation);
    } else if (driverLocation.longitude > userLocation.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(driverLocation.latitude, userLocation.longitude),
        northeast: LatLng(userLocation.latitude, driverLocation.longitude),
      );
    } else if (driverLocation.latitude > userLocation.latitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(userLocation.latitude, driverLocation.longitude),
        northeast: LatLng(driverLocation.latitude, userLocation.longitude),
      );
    } else {
      boundsLatLng =
          LatLngBounds(southwest: driverLocation, northeast: userLocation);
    }

    newGoogleMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));

    Marker originMarker = Marker(
      markerId: const MarkerId("originID"),
      position: driverLocation,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    );
    var originLocation =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
      infoWindow: InfoWindow(
          title: originLocation!.locationName, snippet: "Destination"),
      position: userLocation,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );

    setState(() {
      markersSet.add(originMarker);
      markersSet.add(destinationMarker);
    });

    Circle originCircle = Circle(
      circleId: const CircleId("originID"),
      fillColor: Colors.green,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: driverLocation,
    );

    Circle destinationCircle = Circle(
      circleId: const CircleId("destinationID"),
      fillColor: Colors.red,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: userLocation,
    );

    setState(() {
      circlesSet.add(originCircle);
      circlesSet.add(destinationCircle);
    });
  }

  double maxKm = 8;
  // initializeGeoFireListener() {
  //   Geofire.initialize("activeDrivers");

  //   showModalBottomSheet(
  //     context: context,
  //     isDismissible: true,
  //     backgroundColor: Color.fromARGB(255, 250, 250, 249),
  //     elevation: 10,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(15.0),
  //     ),
  //     builder: (BuildContext context) {
  //       return Container(
  //         padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
  //         height: 250,
  //         child: Center(
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             children: const <Widget>[
  //               Image(
  //                   image: AssetImage("assets/truck.png"),
  //                   height: 100,
  //                   width: 120),
  //               Padding(
  //                 padding: EdgeInsets.all(8.0),
  //                 child: Text('Looking for Trucks near by'),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );

  //   Geofire.queryAtLocation(userCurrentPosition!.latitude,
  //           userCurrentPosition!.longitude, userRadius)!
  //       .listen((map) {
  //     print("Listeninggggg");
  //     if (map != null) {
  //       var callBack = map['callBack'];
  //       print(map['key']);
  //       if (map['result'].toString() == '[]') {
  //         print("empty data");
  //         if (userRadius + 1.6 > maxKm) {
  //           userRadius = userRadius;
  //           //  Navigator.pop(context);
  //           Fluttertoast.showToast(
  //               msg: "No Trucks Found. Try After some time...!!");
  //         } else {
  //           setState(() {
  //             userRadius = userRadius + 1.6;
  //           });
  //           // Geofire.stopListener();
  //           increaseRadius();
  //         }
  //       } else {
  //         if (!closed) {
  //           Navigator.pop(context);
  //           closed = true;
  //         }
  //       }
  //       switch (callBack) {
  //         //whenever any driver become active/online
  //         case Geofire.onKeyEntered:
  //           ActiveNearbyAvailableDrivers activeNearbyAvailableDriver =
  //               ActiveNearbyAvailableDrivers();
  //           activeNearbyAvailableDriver.locationLatitude = map['latitude'];
  //           activeNearbyAvailableDriver.locationLongitude = map['longitude'];
  //           activeNearbyAvailableDriver.driverId = map['key'];
  //           GeoFireAssistant.activeNearbyAvailableDriversList
  //               .add(activeNearbyAvailableDriver);
  //           if (activeNearbyDriverKeysLoaded == true) {
  //             displayActiveDriversOnUsersMap();
  //           }
  //           break;

  //         //whenever any driver become non-active/offline
  //         case Geofire.onKeyExited:
  //           GeoFireAssistant.deleteOfflineDriverFromList(map['key']);
  //           displayActiveDriversOnUsersMap();
  //           break;

  //         //whenever driver moves - update driver location
  //         case Geofire.onKeyMoved:
  //           ActiveNearbyAvailableDrivers activeNearbyAvailableDriver =
  //               ActiveNearbyAvailableDrivers();
  //           activeNearbyAvailableDriver.locationLatitude = map['latitude'];
  //           activeNearbyAvailableDriver.locationLongitude = map['longitude'];
  //           activeNearbyAvailableDriver.driverId = map['key'];
  //           GeoFireAssistant.updateActiveNearbyAvailableDriverLocation(
  //               activeNearbyAvailableDriver);
  //           displayActiveDriversOnUsersMap();
  //           break;

  //         //display those online/active drivers on user's map
  //         case Geofire.onGeoQueryReady:
  //           activeNearbyDriverKeysLoaded = true;
  //           displayActiveDriversOnUsersMap();
  //           break;
  //       }
  //     } else {
  //       print("No drivers found");
  //     }
  //   });

  //   LatLng userLatLng =
  //       LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
  //   Circle userCircle = Circle(
  //     visible: true,
  //     circleId: const CircleId("userId"),
  //     fillColor: Colors.transparent,
  //     radius: 1000 * userRadius,
  //     strokeWidth: 2,
  //     strokeColor: Color.fromARGB(255, 99, 234, 249),
  //     center: userLatLng,
  //   );
  //   setState(() {
  //     circlesSet.add(userCircle);
  //   });
  //   print("Got drivers list");

  //   print("Closed");
  //   // Geofire.stopListener();
  // }

  // increaseRadius() {
  //   Geofire.queryAtLocation(userCurrentPosition!.latitude,
  //           userCurrentPosition!.longitude, userRadius)!
  //       .listen((map) {
  //     if (map != null) {
  //       var callBack = map['callBack'];
  //       print(map['result']);
  //       if (map['result'].toString() == '[]') {
  //         print("empty data");
  //         if (userRadius + 1.6 > maxKm) {
  //           userRadius = userRadius;
  //           // Navigator.pop(context);
  //           Fluttertoast.showToast(
  //               msg: "No Trucks Found. Try After some time...!!");
  //         } else {
  //           setState(() {
  //             userRadius = userRadius + 1.6;
  //           });
  //           // Geofire.stopListener();
  //           // increaseRadius();
  //         }
  //       } else {
  //         if (!closed) {
  //           Navigator.pop(context);
  //           closed = true;
  //         }
  //       }
  //       switch (callBack) {
  //         //whenever any driver become active/online
  //         case Geofire.onKeyEntered:
  //           ActiveNearbyAvailableDrivers activeNearbyAvailableDriver =
  //               ActiveNearbyAvailableDrivers();
  //           activeNearbyAvailableDriver.locationLatitude = map['latitude'];
  //           activeNearbyAvailableDriver.locationLongitude = map['longitude'];
  //           activeNearbyAvailableDriver.driverId = map['key'];
  //           GeoFireAssistant.activeNearbyAvailableDriversList
  //               .add(activeNearbyAvailableDriver);
  //           if (activeNearbyDriverKeysLoaded == true) {
  //             displayActiveDriversOnUsersMap();
  //           }
  //           break;

  //         //whenever any driver become non-active/offline
  //         case Geofire.onKeyExited:
  //           GeoFireAssistant.deleteOfflineDriverFromList(map['key']);
  //           displayActiveDriversOnUsersMap();
  //           break;

  //         //whenever driver moves - update driver location
  //         case Geofire.onKeyMoved:
  //           ActiveNearbyAvailableDrivers activeNearbyAvailableDriver =
  //               ActiveNearbyAvailableDrivers();
  //           activeNearbyAvailableDriver.locationLatitude = map['latitude'];
  //           activeNearbyAvailableDriver.locationLongitude = map['longitude'];
  //           activeNearbyAvailableDriver.driverId = map['key'];
  //           GeoFireAssistant.updateActiveNearbyAvailableDriverLocation(
  //               activeNearbyAvailableDriver);
  //           displayActiveDriversOnUsersMap();
  //           break;

  //         //display those online/active drivers on user's map
  //         case Geofire.onGeoQueryReady:
  //           activeNearbyDriverKeysLoaded = true;
  //           displayActiveDriversOnUsersMap();
  //           break;
  //       }
  //     } else {
  //       print("No drivers found");
  //     }
  //   });

  //   circlesSet.clear();
  //   LatLng userLatLng =
  //       LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
  //   Circle userCircle = Circle(
  //     visible: true,
  //     circleId: const CircleId("userId"),
  //     fillColor: Colors.transparent,
  //     radius: 1000 * userRadius,
  //     strokeWidth: 2,
  //     strokeColor: Color.fromARGB(255, 99, 234, 249),
  //     center: userLatLng,
  //   );
  //   setState(() {
  //     circlesSet.add(userCircle);
  //   });
  //   print(userRadius);
  //   CameraPosition cameraPosition =
  //       CameraPosition(target: userLatLng, zoom: 14 - (userRadius / 3));

  //   newGoogleMapController!
  //       .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  // }

  displayActiveDriversOnUsersMap() {
    setState(() {
      //markersSet.clear();
      markersSet.removeWhere(
          (element) => element.markerId != const MarkerId("userMarker"));

      Set<Marker> driversMarkerSet = Set<Marker>();

      for (ActiveNearbyAvailableDrivers eachDriver
          in GeoFireAssistant.activeNearbyAvailableDriversList) {
        LatLng eachDriverActivePosition =
            LatLng(eachDriver.locationLatitude!, eachDriver.locationLongitude!);

        Marker marker = Marker(
            markerId: MarkerId("driver" + eachDriver.driverId!),
            position: eachDriverActivePosition,
            icon: BitmapDescriptor.fromBytes(markerIcon!),
            rotation: 360,
            onTap: () => {print("tapped the marker")},
            infoWindow: InfoWindow(title: eachDriver.driverId));

        driversMarkerSet.add(marker);
      }

      setState(() {
        markersSet.addAll(driversMarkerSet);
      });
    });
  }

  Uint8List? markerIcon;
  createActiveNearByDriverIconMarker() async {
    // print(activeNearbyIcon);
    // if (activeNearbyIcon == null) {
    //   ImageConfiguration imageConfiguration =
    //       createLocalImageConfiguration(context, size: const Size(0.2, 0.2));
    //   BitmapDescriptor.fromAssetImage(imageConfiguration, "assets/car.png")
    //       .then((value) {
    //     activeNearbyIcon = value;
    //   });
    // }
    if (markerIcon == null) {
      markerIcon = await getBytesFromAsset('assets/car.png', 120, 125);
    }
  }

  Future<Uint8List?> getBytesFromAsset(
      String path, int width, int height) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width, targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        ?.buffer
        .asUint8List();
  }
}
