import 'package:flutter/material.dart';
import 'package:color_picker/home.dart';

class App extends StatelessWidget {
  const App({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        fontFamily: "SpaceGroteskBold", // Définition du fontFamily
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
