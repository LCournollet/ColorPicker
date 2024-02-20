import 'package:flutter/material.dart';
import 'choose_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover, // Ajuste l'image pour couvrir tout le conteneur
          ),
        ),
        child: Center(
          child: Text(
            'Welcome to ColorPicker App!',
            style: TextStyle(
              fontSize: 24.0,
              fontFamily: "SpaceGroteskBold",
              decoration: TextDecoration.underline, // Ajout du soulignement
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BottomNavItem(
              title: 'My Colors',
              onPressed: () {
                print('mycolors button pressed');
              },
            ),
            BottomNavItem(
              title: 'Choose a color',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChooseColorsPage()),
                );
              },
            ),
            BottomNavItem(
              title: 'IMAGE',
              onPressed: () {
                print('Image button pressed');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final String title;
  final Function onPressed;

  const BottomNavItem({
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onPressed(),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16.0, color: Colors.blue),
      ),
    );
  }
}
