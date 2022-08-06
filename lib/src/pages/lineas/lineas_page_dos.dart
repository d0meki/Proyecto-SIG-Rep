import 'package:flutter/material.dart';
import 'package:google_maps/src/pages/rutas/rutas_controller.dart';
import 'package:widget_mask/widget_mask.dart';

class PageLinea extends StatefulWidget {
  const PageLinea({Key? key}) : super(key: key);
  @override
  State<PageLinea> createState() => _PageLineaState();
}

class _PageLineaState extends State<PageLinea> {
  RutasController controller = RutasController();
  @override
  Widget build(BuildContext context) {
    final Object? linea = ModalRoute.of(context)!.settings.arguments;
    controller.getLineName(linea);
    return Scaffold(
      appBar: AppBar(
        title: Text("Ruta de ${controller.lineName}",
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 146, 194, 232),
      ),
      body: Center(
          child: Column(
        children: [
          SizedBox(height: 15,),
          buildImageCard(linea, 'assets/img/lineas/${controller.lineName}.jpg')
        ],
      )),
    );
  }

  Widget buildImageCard(linea, String assetImg) => Card(
        color: Color.fromARGB(255, 190, 190, 186),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Column(
          children: [
            Stack(alignment: Alignment.center, children: [
              // Ink.image(
              //   image: AssetImage(assetImg),
              //   height: 240,
              //   fit: BoxFit.cover,
              //   child: InkWell(
              //     onTap: () {},
              //   ),
              // )
              SafeArea(
        child: Center(
          child: WidgetMask(blendMode: BlendMode.srcATop,
          childSaveLayer: true,
          mask: Image.asset(assetImg),
          child: Image.asset('assets/img/lineas/mascara3.png',width: 350,),
          ),
        ),
      ),
            ]),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                    onPressed: () {
                      controller.setTypeLinea(linea, 1);
                      Navigator.pushNamed(
                        context,
                        'linea',
                        arguments: linea,
                      );
                    },

                    icon:const Icon(Icons.arrow_circle_right_outlined),
                    label:const Text('Ruta de Ida')),
                ElevatedButton.icon(
                    onPressed: () {
                      controller.setTypeLinea(linea, 2);
                      Navigator.pushNamed(
                        context,
                        'linea',
                        arguments: linea,
                      );
                    },
                    icon: const Icon(Icons.arrow_circle_left_outlined),
                    label:const Text('Ruta de Vuelta')),
              ],
            ),
            const SizedBox(height: 10,)
          ],
        ),

      );
}
