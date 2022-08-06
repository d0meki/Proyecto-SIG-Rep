// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps/src/data/firebase_provider.dart';
import 'package:google_maps/src/pages/esperar_linea/esperar_line_controller.dart';
import 'package:google_maps/src/pages/esperar_linea/esperar_line_controller2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../utils/map_style.dart';

class EsperarLinePage extends StatefulWidget {
  const EsperarLinePage({Key? key}) : super(key: key);

  @override
  State<EsperarLinePage> createState() => _EsperarLinePageState();
}

class _EsperarLinePageState extends State<EsperarLinePage> {
  late GoogleMapController mapController;
  List<Marker> myMarkers = [];
  Map<CircleId, Circle> myCircle = {};
  double tamCircle = 400;
  LatLng? lugarCirculo;
  Set<Circle> get getCircle => (myCircle.values.toSet());
  //controllers
  FirebaseProvider firebaseProvider = FirebaseProvider();
  final _controller = EsperarLineController();
  final _controllerLineas = EsperarLineController2();
  //PARA OBTENER MI UBICACION
  Location location = new Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  // ignore: prefer_final_fields
  bool _isListenLocation = false, _isGetLocation = false;
  Timer? timer;
  late StreamSubscription subscription;
  @override
  void initState() {
    super.initState();
    _controllerLineas.addListener(() {
      setState(() {});
    });
    subscription = _controller.ubicaciones.snapshots().listen((event) {
      _controller.getUbicacion2(event);
      print('change');
      _controller.addLineasOn();
      _controllerLineas.cargarLineasMapa(_controller.lineasOnCircle);
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Object? ruta = ModalRoute.of(context)!.settings.arguments;
    _controllerLineas.getLineName(ruta); //name linea
    _controller.name = _controllerLineas.lineName;
    _controllerLineas.chargeImage();
    _controllerLineas.cargarLista(ruta);
    _controllerLineas.uploadRoute();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Esperar Lineas'),
          backgroundColor: const Color.fromARGB(255, 146, 194, 232),
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.transform_sharp,
              ),
              onPressed: () {
                // do something
              },
            )
          ],
        ),
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                controller.setMapStyle(mapStyle);
                mapController = controller;
              },
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(-17.78629, -63.18117),
                zoom: 12.4746,
              ),
              onTap: _handleTap,
              markers: _controllerLineas.markers,
              polylines: _controllerLineas.polylines,
              circles: getCircle,
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 8,
                    ),
                    button(_listarDistanceTime, Icons.list, 'btn3'),
                    button(_circuloEnMiUbicacion, Icons.location_pin, 'btn2'),
                  ],
                ),
              ),
            )
          ],
        ));
    // ignore: dead_code
  }

  _handleTap(LatLng tappedPoint) {
    setState(() {
      myMarkers = [];
      myMarkers.add(
        Marker(
            markerId: MarkerId(tappedPoint.toString()), position: tappedPoint),
      );
      lugarCirculo = tappedPoint;
      cargarCircle(tappedPoint);
      _controllerLineas.getDirectionsTime(
          _controller.lineasOnCircle, tappedPoint);
    });
  }

  void _listarDistanceTime() {
    showModalBottomSheet(
        backgroundColor: Color.fromARGB(255, 208, 223, 234),
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (contex) => Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: ListView(
                  children: listar_DistanceTime(),
                ),
              ),
            ));
  }

  void _circuloEnMiUbicacion() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await location.requestService();
      if (_serviceEnabled!) return;
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted != PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return;
    }
    _locationData = await location.getLocation();
    setState(() {
      _isGetLocation = true;
      final p = LatLng(_locationData!.latitude!, _locationData!.longitude!);
      lugarCirculo = p;
      cargarCircle(p);
      mapController.animateCamera( 
        CameraUpdate.newCameraPosition(
              CameraPosition(target: p, zoom: 12.4746) 
              //17 is new zoom level
        )
      );
      _controllerLineas.getDirectionsTime(
          _controller.lineasOnCircle, p);
    });
  }

  List<Widget> listar_DistanceTime() {
    List<Widget> list = [];
    Widget boton = ElevatedButton.icon(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.dangerous_outlined),
        label: Text('Ocultar'));
    list.add(boton);
    list.add(SizedBox(
      height: 15,
    ));
    for (var i = 0; i < _controllerLineas.listDirectionsTime.length; i++) {
      var txt = Card(
          child: ListTile(
        title: Text(
          'Distancia: ' + _controllerLineas.listDirectionsTime[i].totalDistance + ' - Tiempo: ' + _controllerLineas.listDirectionsTime[i].totalDuration,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 106, 101, 101)),
        ),
        // trailing: Icon(Icons.line_axis,color: _controllerLineas.colors[i],),
        leading: Icon(Icons.social_distance),
        onTap: () {
          // _controllerLineas.listObject[i]['type'] = 1;
          // Navigator.pushNamed(context, 'linea',arguments: _controllerLineas.listObject[i]);
        },
      ));
      list.add(txt);
    }
    return list;
  }

  Widget button(function, IconData icon, String description) {
    return FloatingActionButton(
      heroTag: description,
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      backgroundColor: Colors.blue,
      child: Tooltip(
          message: description,
          child: Icon(
            icon,
            size: 30.0,
          )),
    );
  }

  void cargarCircle(posicion) {
    CircleId c = CircleId('1');
    Circle circulo = Circle(
        circleId: c,
        center: posicion,
        radius: tamCircle,
        strokeWidth: 2,
        strokeColor: Colors.green,
        fillColor: Colors.green.withAlpha(70));
    myCircle[c] = circulo;
  }
}
