import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/Handler/appData.dart';
import 'package:ride_sharing/locationScreens/method_request.dart';
import 'package:ride_sharing/screens/search_Screen.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:ride_sharing/widget/custom_drawer.dart';
import 'package:flutter/services.dart';

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
  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polyLineSet = {};

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    currentPosition = position;
    LatLng lang = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = CameraPosition(target: lang, zoom: 14.4746);

    if (userMap != null) {
      userMap!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    }

    String address =
        await MethodRequest.methodRequestCoordinated(context, position);
    print(address); // You can print the address here
  }

  void checkLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      // Initialize the map after the permission is granted
      _initializeMap();
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

  void _initializeMap() {
    setState(() {
      // Initialize the map here
    });
    // Call getCurrentLocation after the map is initialized
    getCurrentLocation();
  }

  void _navigateToSearchScreen() async {
    var res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchScreen(),
      ),
    );

    // Check if the result is not null and it's of type DirectionPlace
    if (res == "sucessfull") {
      await getPlaceDirection();
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
                  polylines: polyLineSet,
                  zoomGesturesEnabled: true,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    _newGoolgeController.complete(controller);
                    userMap = controller;
                    checkLocationPermission();
                    setState(() {});
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
                    InkWell(
                      onTap: _navigateToSearchScreen,
                      child: Container(
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

  Future<void> getPlaceDirection() async {
    var initialPosition = Provider.of<AppData>(context, listen: false).rAddress;
    var finalPosition = Provider.of<AppData>(context, listen: false).dAddress;

    if (initialPosition == null || finalPosition == null) {
      print("Error: Invalid initial or final position");
      return null;
    }

    var pickLatLang =
        LatLng(initialPosition.latitude!, initialPosition.longitude!);
    var dropLatLang = LatLng(finalPosition.latitude!, finalPosition.longitude!);

    var details =
        await MethodRequest.getLocationDirection(pickLatLang, dropLatLang);
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodePolyPoints =
        polylinePoints.decodePolyline(details!.encodedPoints);

    if (decodePolyPoints.isNotEmpty) {
      pLineCoordinates.clear(); // Clear the list before adding new points

      decodePolyPoints.forEach((PointLatLng pointLatLng) {
        pLineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });

      print(
          "Polyline Points: $pLineCoordinates"); // Check if this prints valid coordinates

      polyLineSet.clear();

      polyLineSet.clear();
      setState(() {
        Polyline polyLinee = Polyline(
          polylineId: PolylineId("PolylineID"),
          jointType: JointType.round,
          color: Colors.blue.shade900,
          width: 2,
          endCap: Cap.squareCap,
          startCap: Cap.roundCap,
          points: pLineCoordinates,
          geodesic: true,
        );
        polyLineSet.add(polyLinee);
      });
      fitMapToBounds(pLineCoordinates);
    }
  }

  void fitMapToBounds(List<LatLng> bounds) {
    if (userMap != null && bounds.isNotEmpty) {
      double minLat = bounds[0].latitude;
      double maxLat = bounds[0].latitude;
      double minLng = bounds[0].longitude;
      double maxLng = bounds[0].longitude;

      // Find the minimum and maximum latitude and longitude values
      for (LatLng point in bounds) {
        if (point.latitude < minLat) minLat = point.latitude;
        if (point.latitude > maxLat) maxLat = point.latitude;
        if (point.longitude < minLng) minLng = point.longitude;
        if (point.longitude > maxLng) maxLng = point.longitude;
      }

      // Create the LatLngBounds to fit all the points
      LatLng southwest = LatLng(minLat, minLng);
      LatLng northeast = LatLng(maxLat, maxLng);
      LatLngBounds boundsObject =
          LatLngBounds(southwest: southwest, northeast: northeast);

      // Set camera position to fit the LatLngBounds with some padding (100)
      CameraUpdate cameraUpdate =
          CameraUpdate.newLatLngBounds(boundsObject, 100);

      // Animate the camera to the new position
      userMap!.animateCamera(cameraUpdate);
    }
  }
}
