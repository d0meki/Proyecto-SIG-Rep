import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class ViewLineController {
  ViewLineController();

  final docLineas = FirebaseFirestore.instance.collection("Lineas");
  // ignore: prefer_final_fields
  List _lineas = [];
  List _lineasOnCircle = [];
  List get lineasOnCircle => _lineasOnCircle;
  final double distance = 3.716971886 * pow(10, -3);

  Future<void> getLines() async {
    docLineas.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _lineas.add(doc.data());
      });
    });
  }

  double distanceAB(LatLng a, LatLng b) {
    double x = (b.longitude - a.longitude);
    double y = (b.latitude - a.latitude);
    double dist = sqrt(pow(x, 2) + pow(y, 2));
    return dist;
  }

  void addLinesOnCircle(LatLng pos) {
    _lineasOnCircle = [];
    for (var i = 0; i < _lineas.length; i++) {
      final lineida = _lineas[i]['LI'];
      final lineavuelta = _lineas[i]['LV'];
      bool li = verifPositionOnCircle(lineida, pos);
      bool lv = verifPositionOnCircle(lineavuelta, pos);
      if (li || lv) {
        print(_lineas[i]['name']);
        _lineasOnCircle.add(_lineas[i]);
      }
    }
  }

  bool verifPositionOnCircle(dynamic linea, LatLng pos) {
    final cordenadas = linea['coordenadas'];
    for (var j = 0; j < cordenadas.length; j++) {
      double dist = distanceAB(
          LatLng(cordenadas[j]['latitud'], cordenadas[j]['longitud']), pos);
      if (dist <= distance) {
        // print(dist);
        return true;
      }
    }
    return false;
  }
}
