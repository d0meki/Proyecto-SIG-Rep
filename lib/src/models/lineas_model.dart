// To parse this JSON data, do
//
//     final lineas = lineasFromJson(jsonString);

import 'dart:convert';

Lineas lineasFromJson(String str) => Lineas.fromJson(json.decode(str));

String lineasToJson(Lineas data) => json.encode(data.toJson());

class Lineas {
  Lineas({
    this.lineas,
  });

  List<Linea>? lineas;

  factory Lineas.fromJson(Map<String, dynamic> json) => Lineas(
        lineas: List<Linea>.from(json["Lineas"].map((x) => Linea.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Lineas": List<dynamic>.from(lineas!.map((x) => x.toJson())),
      };
}

class Linea {
  Linea({
    this.linea,
  });

  List<Cordenada>? linea;

  factory Linea.fromJson(Map<String, dynamic> json) => Linea(
        linea: List<Cordenada>.from(
            json["linea"].map((x) => Cordenada.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "linea": List<dynamic>.from(linea!.map((x) => x.toJson())),
      };
}

class Cordenada {
  Cordenada({
    this.latitud,
    this.longitud,
  });

  String? latitud;
  String? longitud;

  factory Cordenada.fromJson(Map<String, dynamic> json) => Cordenada(
        latitud: json["latitud"],
        longitud: json["longitud"],
      );

  Map<String, dynamic> toJson() => {
        "latitud": latitud,
        "longitud": longitud,
      };
}
