import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class EsperarLineController {
  EsperarLineController();

  final docLineas = FirebaseFirestore.instance.collection("Lineas");
  final ubicaciones = FirebaseFirestore.instance.collection('Ubicaciones');
  final List _ubicacionesLineas = [];
  String name = "";
  final List _lineasOnCircle = [];
  Timer? timer;
  List get lineasOnCircle => _lineasOnCircle;
  List get ubicacionesLineas => _ubicacionesLineas;
  final double distance = 3.716971886 * pow(10, -3);

  void getUbicacion2(dynamic event) {
    _ubicacionesLineas.clear();
    for (var doc in event.docs) {
      _ubicacionesLineas.add(doc);
    }
  }

  void addLineasOn() {
    _lineasOnCircle.clear();
    _ubicacionesLineas.forEach((doc) {
      dynamic data = doc.data();
      if (data['name'] == name && data['state']) {
        var array = data['cordenadas'];
        _lineasOnCircle.add(array[array.length - 1]);
      }
    });
  }
}
