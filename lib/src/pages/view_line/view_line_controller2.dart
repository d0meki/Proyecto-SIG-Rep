import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ViewLineController2 extends ChangeNotifier {
  Map<MarkerId, Marker> _markers = {};
  Set<Marker> get markers => _markers.values.toSet();

  final Map<PolylineId, Polyline> _polylines = {};
  Set<Polyline> get polylines => _polylines.values.toSet();

  List<List<LatLng>> listPositions = [];
  List<String> lineName = [];
  List<dynamic> listObject = [];
  final List<Color> colors = [
    Colors.purple,
    Colors.green.shade600,
    Colors.orange.shade600,
    Colors.indigoAccent.shade700,
    Colors.teal,
    Colors.red.shade600,
    Colors.blueGrey,
    Colors.lime.shade400,
    Colors.blue.shade300,
    Colors.yellow.shade400,
    Colors.purple,
    Colors.green.shade600,
    Colors.orange.shade600,
    Colors.indigoAccent.shade700,
    Colors.teal,
    Colors.red.shade600,
    Colors.blueGrey,
    Colors.lime.shade400,
    Colors.blue.shade300,
    Colors.yellow.shade400
  ];

  void cargarLista(List<dynamic> data) {
    _polylines.clear();
    listPositions.clear();
    _markers.clear();
    lineName = [];
    listObject = [];
    data.forEach((linea) {
      final Li = linea['LI'];
      final Lv = linea['LV'];
      List<LatLng> listPosition = [];
      loadParadas(linea);
      Li['coordenadas'].forEach((cordenada) {
        LatLng position = LatLng(cordenada['latitud'], cordenada['longitud']);
        listPosition.add(position);
      });
      String txt = linea['name'];
      if (!contains(txt)) {
        listPositions.add(listPosition);
        lineName.add(linea['name']);
        listObject.add(linea);
      }
    });
  }
  bool contains(data){
    for (var i = 0; i < lineName.length; i++) {
      if (lineName[i]==data) {
        return true;
      }
    }
    return false;
  }

  void uploadRoute() {
    _polylines.clear();
    Random rand = Random();
    for (var i = 0; i < listPositions.length; i++) {
      int randNum = rand.nextInt((colors.length - 1));
      PolylineId polyline1Id = PolylineId("id$i");
      Polyline polyline = Polyline(
        polylineId: polyline1Id,
        points: listPositions[i],
        color: colors[i],
        width: 5,
      );

      _polylines[polyline1Id] = polyline;
    }
    notifyListeners();
  }

  // markers
  void addMarker(LatLng position, double colorMarker, String infoMarker) {
    MarkerId markerId = MarkerId(position.toString());
    Marker marker = Marker(
      markerId: markerId,
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(colorMarker),
      infoWindow: InfoWindow(
        title: infoMarker,
      ),
      draggable: true,
    );
    _markers[markerId] = marker;
  }

  void loadParadas(data) {
    final Li = data['LI'];
    addMarker(
        LatLng(
            Li["coordenadas"][0]["latitud"], Li["coordenadas"][0]["longitud"]),
        BitmapDescriptor.hueViolet,
        data['name']);

    addMarker(
        LatLng(Li["coordenadas"][Li["coordenadas"].length - 1]["latitud"],
            Li["coordenadas"][Li["coordenadas"].length - 1]["longitud"]),
        BitmapDescriptor.hueViolet,
        data['name']);
  }


  @override
  void dispose() {
    _markers.clear();
    _polylines.clear();
    super.dispose();
  }
}
