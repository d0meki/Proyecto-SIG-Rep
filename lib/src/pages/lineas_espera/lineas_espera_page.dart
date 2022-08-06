import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LineasEsperaPage extends StatelessWidget {
  const LineasEsperaPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> lineasStream = FirebaseFirestore.instance
        .collection("Lineas")
        .orderBy('id')
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: lineasStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
            return Card(
              child: ListTile(
                title: Text('${lineas['name']}'),
                trailing:
                    const Icon(Icons.directions_transit, color: Color.fromARGB(255, 112, 122, 234)),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    'lineas_espera',
                    arguments: lineas,
                  );
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
