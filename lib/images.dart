import 'package:flutter/material.dart';
import 'package:color_picker/imageOne.dart'; // Import the ImageOne file

void main() {
  runApp(MaterialApp(
    home: ImagePage(),
  ));
}

class ImagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Images'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImagePickerScreen()),
                );
              },
              child: Text('Open Image 1'),
            ),
          ],
        ),
      ),
    );
  }
}
