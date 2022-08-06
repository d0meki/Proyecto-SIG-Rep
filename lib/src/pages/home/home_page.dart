import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps/src/pages/home/home_controller.dart';
import 'package:google_maps/src/pages/lineas/lineas_search.dart';
import 'package:google_maps/src/pages/lineas/lineas_search_delegate.dart';
import 'package:google_maps/src/pages/pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String pagina = "Lista de Lineas";
  final _controller = HomeController();
  int _optionSelected = 0;
  final List<Widget> pages = [
    //const LineasBuscar(),
    const LineasPage(),
    const ViewLinePage(),
    const LineasEsperaPage()
  ];
  @override
  Widget build(BuildContext context) {
    _controller.init();
    if (false) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Text(
                  'Para usar la app nesecitamos acceder a tu ubicación,\n habilita el GPS',
                  textAlign: TextAlign.center),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    Geolocator.openLocationSettings();
                  });
                },
                child: const Text('Ir a Habilitar GPS'),
              )
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(pagina),
          backgroundColor: const Color.fromARGB(255, 146, 194, 232),
          elevation: 0,
          actions: (pagina == "Lista de Lineas")?<Widget>[
            IconButton(
              icon: const Icon(
                Icons.search,
              ),
              onPressed: () {
                //aqui llamaremos al SearchDelegate
                showSearch(context: context, delegate: BuscarLinea());
              },
            )
          ]:null,
        ),
        body: Center(
          child: pages.elementAt(_optionSelected),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_transportation_outlined),
              label: 'Rutas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.radio_button_on),
              label: 'Buscar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_pin_circle_rounded),
              label: 'Esperar',
            ),
          ],
          currentIndex: _optionSelected,
          selectedItemColor: const Color.fromARGB(255, 60, 152, 227),
          onTap: (value) {
            setState(() {
              _optionSelected = value;
              if (value == 0) {
                pagina = "Lista de Lineas";
              }
              if (value == 1) {
                pagina = "Buscar";
              }
              if (value == 2) {
                pagina = "Esperar";
              }
            });
          },
        ),
      );
    }
  }
}
