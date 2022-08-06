import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class HomeController extends ChangeNotifier {
  bool _isGpsEnabled = false;
  bool get isGpsEnalbled => _isGpsEnabled;
  StreamSubscription? gpsSubscription;
  HomeController();

  Future<void> init() async {
    _isGpsEnabled = await Geolocator.isLocationServiceEnabled();
    gpsSubscription = Geolocator.getServiceStatusStream().listen((status) {
      _isGpsEnabled = status == ServiceStatus.enabled;
      notifyListeners();
    });
    notifyListeners();
  }
}
