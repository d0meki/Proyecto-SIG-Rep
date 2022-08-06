import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps/src/pages/rutas/rutas_controller.dart';

class RoutesPage extends StatefulWidget {
  const RoutesPage({Key? key}) : super(key: key);

  @override
  State<RoutesPage> createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> {
  RutasController controller = RutasController();
  @override
  Widget build(BuildContext context) {
    final Object? ruta = ModalRoute.of(context)!.settings.arguments;
    controller.getLineName(ruta);
    controller.cargarLista(ruta);
    controller.loadParadas(ruta);
    controller.uploadRoute();
    return Scaffold(
      appBar: AppBar(
        title: Text("Ruta de ${controller.lineName}",style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold ),),
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.grey[800], fontSize: 20),
        backgroundColor: Color.fromARGB(255, 146, 194, 232),
        elevation: 0,
      ),
      body: GoogleMap(
        onMapCreated: controller.onMapCreated,
        initialCameraPosition: controller.initialCameraPosition,
        zoomControlsEnabled: true,
        markers: controller.markers,
        polylines: controller.polylines,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
           Navigator.pushNamed(
                            context,
                            'home',
                          );
        },
        child: const Icon(Icons.home),
        backgroundColor: Color.fromARGB(255, 152, 187, 236),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
