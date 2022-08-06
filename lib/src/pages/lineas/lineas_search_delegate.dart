import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class BuscarLinea extends SearchDelegate {
  final CollectionReference _firebaseStore =
      FirebaseFirestore.instance.collection("Lineas");

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return <Widget>[
      IconButton(
          onPressed: () {
            //consulta
            query = "";
          },
          icon: Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return StreamBuilder<QuerySnapshot>(
      stream: _firebaseStore.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.data!.docs
              .where((QueryDocumentSnapshot<Object?> element) => element['name']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
              .isEmpty) {
            return Center(
              child: Text("No se encontró linea"),
            );
          } else {
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              children: [
                ...snapshot.data!.docs
                    .where((QueryDocumentSnapshot<Object?> element) =>
                        element['name']
                            .toString()
                            .toLowerCase()
                            .contains(query.toLowerCase()))
                    .map((QueryDocumentSnapshot<Object?> data) {
                  final String nombreLinea = data.get('name');
                  final starColor = data.get('startColor');
                  final endColor = data.get('endColor');
                  //return ListTile(title: Text(nombreLinea), onTap: () {});
                  return Center(
                      child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: BounceInLeft(
                      delay: Duration(milliseconds: 500),
                      child: Stack(children: <Widget>[
                        Container(
                          height: 58,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: LinearGradient(
                                  colors: [
                                    Color(int.parse(starColor)),
                                    Color(int.parse(endColor))
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(int.parse(endColor)),
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
                                Color(int.parse(starColor)),
                                Color(int.parse(endColor)),
                                24),
                          ),
                        ),
                        ListTile(
                          title: Text(nombreLinea),
                          trailing: Icon(Icons.directions_transit,
                              color: Color(int.parse(starColor))),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              'lineas',
                              arguments: data.data(),
                            );
                          },
                        ),
                      ]),
                    ),
                  ));
                })
              ],
            );
          }
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return StreamBuilder<QuerySnapshot>(
      stream: _firebaseStore.orderBy('id').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          children: [
            ...snapshot.data!.docs.map((QueryDocumentSnapshot<Object?> data) {
              final String nombreLinea = data.get('name');
              final starColor = data.get('startColor');
              final endColor = data.get('endColor');
              return Center(
                  child: Padding(
                padding: EdgeInsets.all(8.0),
                child: BounceInLeft(
                  delay: Duration(milliseconds: 500),
                  child: Stack(children: <Widget>[
                    Container(
                      height: 58,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                              colors: [
                                Color(int.parse(starColor)),
                                Color(int.parse(endColor))
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight),
                          boxShadow: [
                            BoxShadow(
                                color: Color(int.parse(endColor)),
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
                            Color(int.parse(starColor)),
                            Color(int.parse(endColor)),
                            24),
                      ),
                    ),
                    ListTile(
                      title: Text(nombreLinea),
                      trailing: Icon(Icons.directions_transit,
                          color: Color(int.parse(starColor))),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          'lineas',
                          arguments: data.data(),
                        );
                      },
                    ),
                  ]),
                ),
              ));
            })
          ],
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
