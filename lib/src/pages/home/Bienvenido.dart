import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps/src/pages/alerta_home_permiso/alert_home.dart';

class Bienvenido extends StatefulWidget {
  const Bienvenido({Key? key}) : super(key: key);

  @override
  State<Bienvenido> createState() => _BienvenidoState();
}

class _BienvenidoState extends State<Bienvenido> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xff181FB1),
               Color(0xff12A4EB),
            ],
          )),
          child: Center(
            child: AnimatedSplashScreen(
              backgroundColor:Color.fromARGB(255, 255, 255, 255).withOpacity(0.1),
              splash: Image.asset('assets/img/lineas/linea cruz.png'),
              nextScreen: AlertHomePage(),
              splashTransition: SplashTransition.scaleTransition,
              splashIconSize: 200,
            ),
          ),
        ),
      ),
    );
  }
}
