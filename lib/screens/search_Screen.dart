import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ride_sharing/Handler/appData.dart';
import 'package:ride_sharing/Models/placesJson.dart';
import 'package:ride_sharing/Models/riderAddress.dart';
import 'package:ride_sharing/locationScreens/request_location.dart';
import 'package:ride_sharing/screens/homePage.dart';
import 'package:ride_sharing/widget/progressBar.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {
  TextEditingController pickupController = TextEditingController();
  TextEditingController dropController = TextEditingController();
  List<PlacesJson> placePredictionList = [];

  @override
  Widget build(BuildContext context) {
    String pickupAddress = Provider.of<AppData>(context).rAddress?.pName ?? " ";
    pickupController.text = pickupAddress;
    return Scaffold(
      body: Column(
        children: [
          Material(
            elevation: 6.0,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
            child: Container(
              height: 240.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => home_Screen(),
                                  ));
                            },
                            child: Icon(
                              Icons.arrow_back_outlined,
                              size: 20.0,
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Text(
                            'Add Your Designation...!',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      controller: pickupController,
                      style: TextStyle(fontSize: 18.0),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.location_on_rounded,
                          size: 30.0,
                        ),
                        hintText: "Add Pickup Location",
                        hintStyle: TextStyle(fontSize: 18.0),
                        fillColor: Colors.grey.shade400,
                        filled: true,
                        border: InputBorder.none,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      onChanged: (value) {
                        autoComplete(value);
                      },
                      style: TextStyle(fontSize: 18.0),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.location_on_rounded,
                          size: 30.0,
                        ),
                        hintText: "Add Drop Location",
                        hintStyle: TextStyle(fontSize: 18.0),
                        fillColor: Colors.grey.shade400,
                        filled: true,
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          (placePredictionList.length > 0)
              ? Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                    child: ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      padding: EdgeInsets.all(0.0),
                      itemBuilder: (context, index) {
                        return PlaceTile(
                          key: ValueKey(index),
                          placePrediction: placePredictionList[index],
                          onPlaceSelected:
                              placeDetails, // Pass the callback here
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(),
                      itemCount: placePredictionList.length,
                      physics: ClampingScrollPhysics(),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  void autoComplete(String placeAddress) async {
    if (placeAddress.length > 1) {
      String autoCompleteUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeAddress&location=24.8546842%2C67.0207055&radius=100000&strictbounds=true&types=establishment&key=AIzaSyC0olNwARzr0IQI5gqtb1qxuuPOwfKQNIw";

      try {
        var result = await RequestAddress.getRequest(autoCompleteUrl);
        if (result.containsKey('status') && result['status'] == 'OK') {
          // Parse the predictions from the response
          List<dynamic> predictions = result['predictions'];

          List<PlacesJson> placeList =
              predictions.map((e) => PlacesJson.fromJson(e)).toList();

          // Update the state with the new values
          setState(() {
            placePredictionList = placeList;
          });
        } else {
          // Handle API error or no results case
          print('Failed to get predictions');
        }
      } catch (e) {
        // Handle exceptions here
        print('Error: $e');
      }
    }
  }

  void placeDetails(String placeId) async {
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) => ProgressBar(
          icon: Icon(Icons.access_time),
          onCompleted: () {},
        ),
      );
      String detailUrl =
          "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=AIzaSyC0olNwARzr0IQI5gqtb1qxuuPOwfKQNIw";

      var result = await RequestAddress.getRequest(detailUrl);
      Navigator.of(context, rootNavigator: true)
          .pop(); // Dismiss the progress dialog

      if (result.containsKey('status') && result['status'] == 'OK') {
        RiderAddress riderAddress = RiderAddress();
        riderAddress.pId = placeId;
        riderAddress.pName = result["result"]["name"];
        riderAddress.latitude = result["result"]["geometry"]["location"]["lat"];
        riderAddress.longitude =
            result["result"]["geometry"]["location"]["lng"];
        Provider.of<AppData>(context, listen: false)
            .updateRiderDropofLocation(riderAddress);
        print(riderAddress.pName);
      } else {
        // Handle API error or no results case
        print('Failed to get predictions');
      }
    } catch (e) {
      // Handle exceptions here
      print('Error: $e');
      Navigator.of(context, rootNavigator: true)
          .pop(); // Dismiss the progress dialog in case of an error
    }
  }
}

class PlaceTile extends StatelessWidget {
  final PlacesJson placePrediction;
  final Function(String) onPlaceSelected;

  PlaceTile(
      {required Key key,
      required this.placePrediction,
      required this.onPlaceSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (placePrediction.secondary_text == null) {
      // Return an empty container or a placeholder widget when data is null
      return Container();
    }

    return InkWell(
      onTap: () {
        final placeId = placePrediction.place_id ??
            ""; // Use empty string as default if place_id is null
        onPlaceSelected(placeId);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.location_on_rounded,
              size: 25,
              color: Colors.blueAccent,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    placePrediction.main_text!,
                    maxLines: 1, // Limit to 1 line with ellipsis
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 21.0),
                  ),
                  Text(
                    placePrediction.secondary_text!,
                    maxLines: 1, // Limit to 1 line with ellipsis
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
