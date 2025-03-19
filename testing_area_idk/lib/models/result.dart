import 'package:flutter/widgets.dart';
import 'package:testing_area_idk/models/location.dart';

class Result extends ChangeNotifier {
  List regions = [];
  List provinces = [];
  List cities = [];
  Location location = Location('', '', '');

  void add(String type, List typeList) {
    switch (type) {
      case 'Regions':
        regions = typeList;
      case 'Provinces':
        provinces = typeList;
        break;
      case 'Cities':
        cities = typeList;
        break;
    }
    notify();
  }

  void updateLocation(Location newLocation) {
    location = newLocation;
    notify();
  }

  void notify() {
    Future.delayed(Duration.zero, notifyListeners);
  }
}
