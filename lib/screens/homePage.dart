import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class home_Screen extends StatefulWidget {
  @override
  State<home_Screen> createState() => home_ScreenState();
}

class home_ScreenState extends State<home_Screen> {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Home'),
      ),
      body: Stack(
        children: [
          GoogleMap(initialCameraPosition: _kGooglePlex),
        ],
      ),
    );
  }
}
