import 'package:flutter/material.dart';
import 'package:color_picker/images/generate_image_screen.dart';
import 'package:color_picker/images/imported_picture_screen.dart';

class ImagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Images'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Color(0xFFCFF0FF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GenerateImageScreen()),
                );
              },
              icon: Icon(Icons.image, color: Colors.red),
              label: Text(
                'Generate an image',
                style: TextStyle(color: Colors.red),
              ),
            ),
            SizedBox(height: 80),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImportedPictureScreen()),
                );
              },
              icon: Icon(Icons.photo, color: Colors.green), // Change la couleur de l'icône en vert
              label: Text(
                'Use my images',
                style: TextStyle(color: Colors.green), // Change la couleur du texte en vert
              ),
            ),
          ],
        ),
      ),
    );
  }
}
