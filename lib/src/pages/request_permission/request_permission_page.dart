import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps/src/pages/request_permission/request_permission_controller.dart';
import 'package:permission_handler/permission_handler.dart';

class RequestPermissionPage extends StatefulWidget {
  const RequestPermissionPage({Key? key}) : super(key: key);

  @override
  State<RequestPermissionPage> createState() => _RequestPermissionPageState();
}

class _RequestPermissionPageState extends State<RequestPermissionPage>
    with WidgetsBindingObserver {
  final _controller = RequestPermissionController(Permission.locationWhenInUse);
  late StreamSubscription _subscription;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _subscription = _controller.onStatusChanged.listen((status) {
      if (PermissionStatus.granted == status) {
        Navigator.pushReplacementNamed(context, 'home');
      } else if (PermissionStatus.permanentlyDenied == status) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: const Text('Permisos de Ubicación'),
                  content: const Text('Debe dar permiso Manual'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        openAppSettings();
                      },
                      child: const Text('Ir a configuración'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancelar'),
                    ),
                  ],
                ));
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _subscription.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final status = await _controller.check();
      if (status == PermissionStatus.granted) {
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, 'home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const styleButton = TextStyle(fontSize: 14, color: Colors.white);
    const styleText = TextStyle(fontSize: 16, color: Colors.black);
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Se nesecita Permisos para acceder a la Ubicación',
                  style: styleText),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Habilitar Ubicación', style: styleButton),
                onPressed: () {
                  _controller.request();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
