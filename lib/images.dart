import 'package:flutter/material.dart';
import 'package:color_picker/imageOne.dart';
import 'package:color_picker/imported_picture.dart';// Import the ImageOne file

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
              child: Text('Generate an image'),
            ),
            SizedBox(height: 20), // Add some space between buttons
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImportedPictureScreen()),
                );
              },
              child: Text('Use my images'),
            ),
          ],
        ),
      ),
    );
  }
}
