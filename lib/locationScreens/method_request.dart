import 'package:geolocator/geolocator.dart';
import 'package:ride_sharing/locationScreens/request_location.dart';

class MethodRequest {
  static Future<String> methodRequestCoordinated(Position position) async {
    String desiredAddress = "";
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyC0olNwARzr0IQI5gqtb1qxuuPOwfKQNIw";
    var response = await RequestAddress.getRequest(url);
    if (response != "failed") {
      desiredAddress = response["results"][0]['formatted_address'];
    }
    return desiredAddress;
  }
}
