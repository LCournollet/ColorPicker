import 'package:color_picker/images/images.dart';
import 'package:color_picker/colors/my_colors.dart';
import 'package:flutter/material.dart';
import '../colors/choose_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        color: Color(0xFFCFF0FF),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Image.asset(
                  'assets/logo.png',
                  width: 200,
                ),
              ),
              SizedBox(height: 20), // Espacement entre le logo et le texte
              Text(
                'ColorPicker App!',
                style: TextStyle(
                  fontSize: 36.0,
                  fontFamily: "SpaceGroteskBold",
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 100,
        color: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BottomNavItem(
              title: 'My Colors',
              icon: Icons.account_box,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyColorsPage()),
                );
              },
            ),
            BottomNavItem(
              title: 'Choose a color',
              icon: Icons.palette,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChooseColorsPage()),
                );
              },
            ),
            BottomNavItem(
              title: 'Images',
              icon: Icons.image,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImagePage()),
                );
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
  final IconData icon;
  final Function onPressed;

  const BottomNavItem({
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onPressed(),
      child: Column(
        children: [
          Flexible(
            child: Icon(
              icon,
              color: Colors.blueAccent,
              size: 30,
            ),
          ),
          SizedBox(height: 18),
          Text(
            title,
            style: const TextStyle(fontSize: 16.0, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
