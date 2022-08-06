import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps/src/models/linea_model.dart';

class SearchLinePage extends StatefulWidget {
  const SearchLinePage({Key? key}) : super(key: key);

  @override
  State<SearchLinePage> createState() => _SearchLinePageState();
}

class _SearchLinePageState extends State<SearchLinePage> {
  int? tamData;
  List<Linea>? data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            //aqui haremos el search
            Container(
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    tamData = allLineas
                        .where((elements) =>
                            elements.name.toLowerCase().startsWith(value))
                        .length;

                    data = allLineas
                        .where((elements) =>
                            elements.name.toLowerCase().startsWith(value))
                        .toList();

                    print(tamData);
                  });
                },
                decoration: InputDecoration(
                    hintText: "Search", prefix: Icon(Icons.search)),
              ),
            ),

            // ...List.generate(allLineas.length, (index) {
            //   final snapshot = allLineas[index];
            ...List.generate(
                tamData == null ? allLineas.length : tamData!, //reparar
                (index) {
              final snapshot = data == null ? allLineas[index] : data![index];

              return ListTile(
                title: Text(snapshot.name),
              );
            })
          ],
        ),
      ),
    );
  }
}

