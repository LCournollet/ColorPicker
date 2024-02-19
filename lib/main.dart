import 'package:flutter/material.dart';

void main() {
  runApp(ColorPickerApp());
}

class ColorPickerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ColorPicker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ColorPicker'),
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
                // Add functionality for mycolors button
              },
            ),
            BottomNavItem(
              title: 'Choose colors',
              onPressed: () {
                // Add functionality for Choose colors button
              },
            ),
            BottomNavItem(
              title: 'Image',
              onPressed: () {
                // Add functionality for circle palette button
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
        style: TextStyle(fontSize: 16.0, color: Colors.blue),
      ),
    );
  }
}
