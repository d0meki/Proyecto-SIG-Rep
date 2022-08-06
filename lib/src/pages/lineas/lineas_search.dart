import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps/src/pages/lineas/lineas_search_delegate.dart';

class LineasBuscar extends StatefulWidget {
  const LineasBuscar({Key? key}) : super(key: key);

  @override
  State<LineasBuscar> createState() => _LineasBuscarState();
}

class _LineasBuscarState extends State<LineasBuscar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,  
        children: [
          Text('Cualquier cosa'),
          MaterialButton(
          child: Text('Buscar',style: TextStyle(color: Colors.white),),
          color: Colors.blue,
          shape: StadiumBorder(),
          elevation: 0,
          splashColor: Colors.transparent,
          onPressed: (){
            showSearch(context: context, delegate: BuscarLinea());
          },
          )
        ]),
      ),
    );
  }
}