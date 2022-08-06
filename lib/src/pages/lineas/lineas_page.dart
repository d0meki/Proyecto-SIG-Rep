import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:animate_do/animate_do.dart';

class LineasPage extends StatefulWidget {
  const LineasPage({Key? key}) : super(key: key);

  @override
  State<LineasPage> createState() => _LineasPageState();
}

class _LineasPageState extends State<LineasPage> {
  final double _borderRadius = 24;

  Stream<QuerySnapshot> getAllLineas() {
    return FirebaseFirestore.instance
        .collection("Lineas")
        .orderBy('id')
        .snapshots();
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
          stream: getAllLineas(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text("Error");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              children: snapshot.data!.docs.map((document) {
                Map<String, dynamic> lineas =
                    document.data()! as Map<String, dynamic>;
                return Center(
                    child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: BounceInLeft(
                    delay: Duration(milliseconds: 500),
                    child: Stack(children: <Widget>[
                      Container(
                        height: 58,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(_borderRadius),
                            gradient: LinearGradient(
                                colors: [
                                  Color(int.parse('${lineas['startColor']}')),
                                  Color(int.parse('${lineas['endColor']}'))
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                            boxShadow: [
                              BoxShadow(
                                  color:
                                      Color(int.parse('${lineas['endColor']}')),
                                  blurRadius: 12,
                                  offset: Offset(0, 6))
                            ]),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        top: 0,
                        child: CustomPaint(
                          size: Size(100, 150),
                          painter: CustomCardShapePainter(
                              Color(int.parse('${lineas['startColor']}')),
                              Color(int.parse('${lineas['endColor']}')),
                              _borderRadius),
                        ),
                      ),
                      ListTile(
                        title: Text('${lineas['name']}'),
                        trailing: Icon(Icons.directions_transit,
                            color: Color(int.parse('${lineas['startColor']}'))),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            'lineas',
                            arguments: lineas,
                          );
                        },
                      ),
                    ]),
                  ),
                )
                );
              }).toList(),
            );
          },
        );
  }
}

class CustomCardShapePainter extends CustomPainter {
  final Color startColor;
  final Color endColor;
  final double radius;

  CustomCardShapePainter(this.startColor, this.endColor, this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    var radius = 24.0;
    var paint = Paint();
    paint.shader = ui.Gradient.linear(
        Offset(0, 0), Offset(size.width, size.height), [
      HSLColor.fromColor(startColor).withLightness(0.8).toColor(),
      endColor
    ]);
    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
      ..lineTo(size.width - 1.5 * radius, 0)
      ..quadraticBezierTo(-radius, 2 * radius, 0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
