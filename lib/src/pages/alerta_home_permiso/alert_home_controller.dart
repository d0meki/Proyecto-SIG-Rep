import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_maps/src/routes/routes.dart';

class AlertHomeController extends ChangeNotifier {
  final Permission _locationPermission;
  String? _routeName;
  String? get routeName => _routeName;
  AlertHomeController(this._locationPermission);

  Future<void> checkPermission() async {
    final isGranted = await _locationPermission.isGranted;
    _routeName =
        isGranted ? Routes.routesName['home'] : Routes.routesName['permission'];
    notifyListeners();
  }
}
