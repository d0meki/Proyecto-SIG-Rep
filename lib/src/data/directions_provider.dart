import 'package:dio/dio.dart';
import 'package:google_maps/.env.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/Directions_model.dart';

class DirectionsProvider {
  static const _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';
  final Dio _dio;
  DirectionsProvider() : _dio = Dio();

  Future<dynamic> getDirections(
      {required LatLng origen, required LatLng destination}) async {
    final response = await _dio.get(_baseUrl, queryParameters: {
      'origin': '${origen.latitude}, ${origen.longitude}',
      'destination': '${destination.latitude}, ${destination.longitude}',
      'key': googleAPIKEY
    });
    //check if response is successful
    
    print("RESPUESTA------------------> ${response.data}");

    if (response.statusCode == 200) return Directions.fromMap(response.data);
    
    return null;
  }
}
