import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/Handler/appData.dart';
import 'package:ride_sharing/Models/riderAddress.dart';
import 'package:ride_sharing/locationScreens/request_location.dart';

class MethodRequest {
  static Future<String> methodRequestCoordinated(
    BuildContext context,
    Position position,
  ) async {
    String desiredAddress = "";
    String s1, s2, s3, s4;

    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyC0olNwARzr0IQI5gqtb1qxuuPOwfKQNIw";
    var response = await RequestAddress.getRequest(url);
    if (response != "failed") {
      s1 = response["results"][0]['address_components'][2]["long_name"];
      s2 = response["results"][0]['address_components'][3]["long_name"];
      s3 = response["results"][0]['address_components'][4]["long_name"];
      // s4 = response["results"][0]['address_components'][7]["long_name"];

      desiredAddress = s1 + " , " + s2 + " , " + s3;
      RiderAddress riderAddress = new RiderAddress();

      riderAddress.latitude = position.latitude;
      riderAddress.longitude = position.longitude;
      riderAddress.pName = desiredAddress;
      Provider.of<AppData>(context, listen: false)
          .updateRiderPickupLocation(riderAddress);
    }
    return desiredAddress;
  }
}
