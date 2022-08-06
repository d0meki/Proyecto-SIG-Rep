import 'dart:convert';

class Linea {
  final String name;
  final String? startColor;
  final String? endColor;
  
  Linea({
    required this.name,
    this.startColor,
    this.endColor,
  });
  
  factory Linea.fromJson(String str) => Linea.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());
    factory Linea.fromMap(Map<String, dynamic> json) => Linea(
        name: json["name"],
        startColor: json["startColor"],
        endColor: json["endColor"],
    );
    Map<String, dynamic> toMap() => {
        "name": name,
    };
}

List<Linea> allLineas = [
  Linea(name: "Linea 1"),
  Linea(name: "Linea 2"),
  Linea(name: "Linea 5"),
  Linea(name: "Linea 8"),
  Linea(name: "Linea 9"),
  Linea(name: "Linea 10"),
  Linea(name: "Linea 11"),
  Linea(name: "Linea 16"),
  Linea(name: "Linea 17"),
  Linea(name: "Linea 18"),
];