import 'package:color_picker/images.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Picker'),
      ),
      body: Center(
        child: Text(
          'Welcome to ColorPicker App!',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BottomNavItem(
              title: 'mycolors',
              onPressed: () {
                print('mycolors button pressed');
              },
            ),
            BottomNavItem(
              title: 'Choose colors',
              onPressed: () {
                print('Choose colors button pressed');
              },
            ),
            BottomNavItem(
              title: 'Images',
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
