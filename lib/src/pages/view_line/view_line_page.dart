// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_maps/src/pages/view_line/view_line_controller.dart';
import 'package:google_maps/src/pages/view_line/view_line_controller2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../utils/map_style.dart';
import '../rutas/rutas_controller.dart';

class ViewLinePage extends StatefulWidget {
  const ViewLinePage({Key? key}) : super(key: key);

  @override
  State<ViewLinePage> createState() => _ViewLinePageState();
}

class _ViewLinePageState extends State<ViewLinePage> {
  List<Marker> myMarkers = [];
  Map<CircleId, Circle> myCircle = {};
  double tamCircle = 400;
  LatLng? lugarCirculo;
  Set<Circle> get getCircle => (myCircle.values.toSet());
  //controllers
  RutasController controller = RutasController();
  final _controllerDistance = ViewLineController();
  final _controllerLineas = ViewLineController2();
  //PARA OBTENER MI UBICACION
  Location location = new Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  LatLng pos = LatLng(-17.78629, -63.18117);
  // ignore: prefer_final_fields
  bool _isListenLocation = false, _isGetLocation = false;

  @override
  Widget build(BuildContext context) {
    //final initialPosition = LatLng(_gpsController.myPosition!.latitude, _gpsController.myPosition!.latitude);
    _controllerDistance.getLines();

    return Scaffold(
        body: Stack(
      children: [
        GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            controller.setMapStyle(mapStyle);
          },
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: pos,
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
                button(_listarRutas, Icons.list, 'Listar Rutas'),
                SizedBox(
                  height: 8,
                ),
                button(_circuloEnMiUbicacion, Icons.blur_circular_outlined, 'Cirulo En mi Posicion'),
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
      _controllerDistance.addLinesOnCircle(tappedPoint);
      _controllerLineas.cargarLista(_controllerDistance.lineasOnCircle);
      _controllerLineas.uploadRoute();
    });
  }

  void _listarRutas() {
    showModalBottomSheet(
        backgroundColor: Color.fromARGB(255, 208, 223, 234),
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (contex) => Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: ListView(
                  children: listar_Lineas(),
                ),
              ),
            ));
  }

  List<Widget> listar_Lineas() {
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
    for (var i = 0; i < _controllerLineas.lineName.length; i++) {
      var txt = Card(
          child: ListTile(
        title: Text(
          _controllerLineas.lineName[i],
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 106, 101, 101)),
        ),
        trailing: Icon(Icons.line_axis,color: _controllerLineas.colors[i],),
        onTap: () {
          _controllerLineas.listObject[i]['type'] = 1;
          Navigator.pushNamed(context, 'linea',arguments: _controllerLineas.listObject[i]);
        },
      ));
      list.add(txt);
    }
    return list;
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
      _controllerDistance.addLinesOnCircle(p);
      _controllerLineas.cargarLista(_controllerDistance.lineasOnCircle);
      _controllerLineas.uploadRoute();
    });

  }

  Widget button(function, IconData icon, String description) {
    return FloatingActionButton(
      onPressed: function,
      heroTag: description,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      backgroundColor: Colors.blue,
      splashColor: Colors.amber,
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
