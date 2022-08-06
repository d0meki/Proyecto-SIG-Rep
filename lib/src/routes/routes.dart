import 'package:flutter/material.dart';
import 'package:google_maps/src/pages/home/Bienvenido.dart';
import 'package:google_maps/src/pages/lineas/lineas_page_dos.dart';
import 'package:google_maps/src/pages/lineas/lineas_page_search.dart';
import 'package:google_maps/src/pages/lineas/lineas_search.dart';
import 'package:google_maps/src/pages/lineas/lineas_search_delegate.dart';
import 'package:google_maps/src/pages/pages.dart';

class Routes {
 // static final initialRoute = 'alertPermission';
  static final initialRoute = 'bienvenido';
  static final Map<String, Widget Function(BuildContext)> routes = {
    'home': (BuildContext context) => const HomePage(),
    'alertPermission': (BuildContext context) => const AlertHomePage(),
    'linea': (BuildContext context) => const RoutesPage(),
    'permission': (BuildContext context) => const RequestPermissionPage(),
    'lineas': (BuildContext context) => const PageLinea(),
    'lineas_espera': (BuildContext context) => const PageLineaEspera(),
    'linea_espera': (BuildContext context) => const EsperarLinePage(),
    'bienvenido': (BuildContext context) => const Bienvenido(),
    'search': (BuildContext context) => const SearchLinePage(),
    'buscarLinea': (BuildContext context) => const LineasBuscar(),
  };

  static final routesName = {
    'home': 'home',
    'alertPermission': 'alertPermission',
    'linea': 'linea',
    'permission': 'permission',
    'lineas': 'lineas',
    'lineas_espera': 'lineas_espera',
    'linea_espera': 'linea_espera',
    'bienvenido':'bienvenido'
  };
}
