import 'package:flutter/material.dart';
import 'package:google_maps/src/routes/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      // home: RegisterChoferPage(),
      initialRoute: Routes.initialRoute,
      routes: Routes.routes,
    );
  }
}
