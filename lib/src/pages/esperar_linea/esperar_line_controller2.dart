import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps/src/data/directions_provider.dart';
import 'package:google_maps/src/helper/asset_to_bytes.dart';
import 'package:google_maps/src/models/Directions_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EsperarLineController2 extends ChangeNotifier {
  final Map<MarkerId, Marker> _markers = {};

  final Map<PolylineId, Polyline> _polylines = {};
  Set<Polyline> get polylines => _polylines.values.toSet();
  Set<Marker> get markers => _markers.values.toSet();
  late dynamic icon;
  List<LatLng> listPosition1 = [];
  List<LatLng> listPosition2 = [];

  List<Directions> listDirectionsTime = [];

  String lineName = "";

  void cargarLista(data) {
    _polylines.clear();
    listPosition1 = [];
    listPosition2 = [];
    if (data['type'] == 1) {
      final Li = data['LI'];
      Li['coordenadas'].forEach((cordenada) {
        LatLng position = LatLng(cordenada['latitud'], cordenada['longitud']);
        listPosition1.add(position);
      });
    } else {
      final Lv = data['LV'];
      Lv['coordenadas'].forEach((cordenada) {
        LatLng position = LatLng(cordenada['latitud'], cordenada['longitud']);
        listPosition2.add(position);
      });
    }
  }

  void cargarLineasMapa(List<dynamic> data) {
    _markers.clear();
    //print(data);
    for (var i = 0; i < data.length; i++) {
      dynamic point = data[i];
      addMarker(LatLng(point['latitud'], point['longitud']),
          BitmapDescriptor.hueOrange, 'Linea', i,icon);
    }
    notifyListeners();
  }



  void cambiarLineasMapa(List<dynamic> data) {
    _markers.clear();
    //print(data);
    for (var i = 0; i < data.length; i++) {
      dynamic point = data[i];
      addMarker(LatLng(point['latitud'], point['longitud']),
          BitmapDescriptor.hueOrange, 'Linea', i,icon);
    }
    notifyListeners();
  }

  void getDirectionsTime(List<dynamic> data, LatLng point) {
    listDirectionsTime.clear();
    data.forEach((elem) async {
      dynamic pointer = elem;
      final directions = await DirectionsProvider().getDirections(
          origen: point,
          destination: LatLng(pointer['latitud'], pointer['longitud']));
      listDirectionsTime.add(directions);
    });
  }

  void chargeImage() async {
    icon = await BitmapDescriptor.fromBytes(
        await assetToBytes('assets/img/lineas/bus_icon.png', width: 130));
  }

  void uploadRoute() {
    PolylineId polyline1Id = const PolylineId('id1');
    PolylineId polyline2Id = const PolylineId('id2');

    Polyline polyline1 = Polyline(
      polylineId: polyline1Id,
      points: listPosition1,
      color: Colors.deepPurple,
      width: 3,
    );

    Polyline polyline2 = Polyline(
      polylineId: polyline2Id,
      points: listPosition2,
      color: Colors.green,
      width: 3,
    );

    _polylines[polyline1Id] = polyline1;
    _polylines[polyline2Id] = polyline2;
  }

  // markers
  void addMarker(
      LatLng position, double colorMarker, String infoMarker, int i,dynamic icon2) {
    MarkerId markerId = MarkerId(i.toString());
    Marker marker = Marker(
      markerId: markerId,
      position: position,
      icon: icon2,
      infoWindow: InfoWindow(
        title: infoMarker,
      ),
      draggable: true,
    );
    _markers[markerId] = marker;
  }

  void getLineName(data) {
    lineName = data['name'];
  }

  @override
  void dispose() {
    _markers.clear();
    _polylines.clear();
    super.dispose();
  }
}
