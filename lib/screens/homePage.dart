import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/Handler/appData.dart';
import 'package:ride_sharing/locationScreens/method_request.dart';
import 'package:ride_sharing/widget/custom_drawer.dart';

class home_Screen extends StatefulWidget {
  @override
  State<home_Screen> createState() => home_ScreenState();
}

class home_ScreenState extends State<home_Screen> {
  final Completer<GoogleMapController> _newGoolgeController =
      Completer<GoogleMapController>();
  GoogleMapController? userMap;
  Position? currentPosition;
  var geolocator = Geolocator();

  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    currentPosition = position;
    LatLng lang = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = CameraPosition(target: lang, zoom: 14.4746);
    userMap!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    String address = await MethodRequest.methodRequestCoordinated(
        context, position); // Pass the context parameter
  }

  void checkLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      getCurrentLocation();
    } else if (status.isDenied) {
      // The user denied access to the location
      // You can show a dialog or a snackbar to inform the user
      print('Location permissions denied');
    } else if (status.isPermanentlyDenied) {
      // The user denied access to the location permanently
      // You can show a dialog with instructions on how to grant permissions from settings
      print('Location permissions permanently denied');
    }
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(24.8546842, 67.0207055),
    zoom: 14.4746,
  );

  EdgeInsets mapPadding = EdgeInsets.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WELCOME'),
      ),
      drawer: CustomDrawer(),
      body: Stack(
        children: [
          Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              bottom: 305.0,
              child: Container(
                child: GoogleMap(
                  initialCameraPosition: _kGooglePlex,
                  mapType: MapType.normal,
                  zoomControlsEnabled: true,
                  zoomGesturesEnabled: true,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    _newGoolgeController.complete(controller);
                    userMap = controller;
                    setState(() {});
                    checkLocationPermission();
                  },
                ),
              )),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              height: 320.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18.0),
                      topRight: Radius.circular(18.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 16.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ]),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "Welcome...",
                      style: TextStyle(fontSize: 15.0),
                    ),
                    Text(
                      "Where You want to go?",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 6.0,
                              spreadRadius: 0.5,
                              offset: Offset(0.7, 0.7),
                            ),
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: 16.0,
                            ),
                            Text(
                              "Search Drop Off",
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.home,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            
                            children: [
                              Text(
                                Provider.of<AppData>(context).rAddress?.pName ??
                                    "Add Home",
                                overflow: TextOverflow.clip,
                              ),
                              SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                "Add Your Home Location",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Divider(
                      color: Colors.blue,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.work,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Add Office",
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            Text(
                              "Add Your Work Location",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
