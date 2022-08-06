import 'package:flutter/material.dart';
import 'package:google_maps/src/pages/alerta_home_permiso/alert_home_controller.dart';
import 'package:permission_handler/permission_handler.dart';

class AlertHomePage extends StatefulWidget {
  const AlertHomePage({Key? key}) : super(key: key);

  @override
  State<AlertHomePage> createState() => _AlertHomePageState();
}

class _AlertHomePageState extends State<AlertHomePage> {
  final _controller = AlertHomeController(Permission.locationWhenInUse);
  @override
  void initState() {
    super.initState();
    setState(() {
      _controller.checkPermission();
      _controller.addListener(() {
        if (_controller.routeName != null) {
        Navigator.pushReplacementNamed(context, _controller.routeName!);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      semanticsLabel: 'loaging...',
    );
  }
}
