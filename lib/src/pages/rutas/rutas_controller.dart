import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utils/map_style.dart';

class RutasController {
  Set<Marker> markers = {};
  String lineName = "";

  final Map<PolylineId, Polyline> _polylines = {};
  Set<Polyline> get polylines => _polylines.values.toSet();

  final CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(-17.783113, -63.181359),
    zoom: 12,
  );
  List<LatLng> listPosition1 = [];
  List<LatLng> listPosition2 = [];

  void addMarker(LatLng position, double colorMarker, String infoMarker) {
    markers.add(Marker(
      markerId: MarkerId(position.toString()),
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(colorMarker),
      infoWindow: InfoWindow(
        title: infoMarker,
      ),
      draggable: true,
    ));
  }

  void loadParadas(data) {
    
    
    //linea de ida
    if (data['type'] == 1) {
      final Li = data['LI'];
          addMarker(
        LatLng(
            Li["coordenadas"][0]["latitud"], Li["coordenadas"][0]["longitud"]),
        BitmapDescriptor.hueMagenta,
        'Inicio');

    addMarker(
        LatLng(Li["coordenadas"][Li["coordenadas"].length - 1]["latitud"],
            Li["coordenadas"][Li["coordenadas"].length - 1]["longitud"]),
        BitmapDescriptor.hueMagenta,
        'Fin');
    }else{
      final Lv = data['LV'];
       addMarker(
        LatLng(
            Lv["coordenadas"][0]["latitud"], Lv["coordenadas"][0]["longitud"]),
        BitmapDescriptor.hueMagenta,
        'Inicio');

    addMarker(
        LatLng(Lv["coordenadas"][Lv["coordenadas"].length - 1]["latitud"],
            Lv["coordenadas"][Lv["coordenadas"].length - 1]["longitud"]),
        BitmapDescriptor.hueMagenta,
        'Fin');
    }

    // linea de vuelta
   
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(mapStyle);
  }

  void cargarLista(data) {
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

  void uploadRoute() {
    PolylineId polyline1Id = const PolylineId('id1');
    PolylineId polyline2Id = const PolylineId('id2');

    Polyline polyline1 = Polyline(
      polylineId: polyline1Id,
      points: listPosition1,
      color: Colors.red,
      width: 5,
    );

    Polyline polyline2 = Polyline(
      polylineId: polyline2Id,
      points: listPosition2,
      color: Colors.green,
      width: 5,
    );

    _polylines[polyline1Id] = polyline1;
    _polylines[polyline2Id] = polyline2;
  }

  void getLineName(data) {
    lineName = data['name'];
  }

  void setTypeLinea(data, int tipo) {
    if (tipo == 1) {
      data['type'] = 1;
    } else {
      data['type'] = 2;
    }
  }
}
