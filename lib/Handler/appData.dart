import 'package:flutter/foundation.dart';
import 'package:ride_sharing/Models/riderAddress.dart';

class AppData extends ChangeNotifier {
  RiderAddress? rAddress, dAddress;
  void updateRiderPickupLocation(RiderAddress riderAddress) {
    rAddress = riderAddress;
    notifyListeners();
  }

  void updateRiderDropofLocation(RiderAddress dropLocation) {
    dAddress = dropLocation;
    notifyListeners();
  }
}
