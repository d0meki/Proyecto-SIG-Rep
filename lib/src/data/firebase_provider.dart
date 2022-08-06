import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseProvider {
  final docLineas = FirebaseFirestore.instance.collection("Lineas");
  final _ubicaciones = FirebaseFirestore.instance.collection('Ubicaciones');
  List _lineas = [];
  List _ubicacionesLineas = [];
  List get lineas => _lineas;
  List get ubicacionesLineas => _ubicacionesLineas;
  CollectionReference get ubicaciones => _ubicaciones;
  FirebaseProvider();

  Future<void> getLines() async {
    _lineas = [];
    docLineas.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _lineas.add(doc.data());
      });
    });
  }

  Future<void> addUbicacion(Map<String, dynamic> data, id) async {
    await _ubicaciones.doc(id).set(data);
  }

  Future<void> getUbicacion(String linea) async {
    _ubicaciones.get().then((QuerySnapshot querySnapshot) => {
          querySnapshot.docs.forEach((doc) {
            dynamic data = doc.data();
            if (data['name'] == linea && data['state']) {
              _ubicacionesLineas.add(doc.data());
            }
          })
        });
  }
}
