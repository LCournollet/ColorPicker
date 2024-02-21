//Page avec les deux boutons de sélection

import 'package:flutter/material.dart';
import 'package:color_picker/images/generate_image_screen.dart';
import 'package:color_picker/images/imported_picture_screen.dart';

class ImagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Images'), // Titre de la page
        centerTitle: true, // Centrer le titre dans la barre d'applications
        backgroundColor: Colors.blue, // Couleur de fond de la barre d'applications
      ),
      backgroundColor: Color(0xFFCFF0FF), // Couleur de fond de la page
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centrer le bouton
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GenerateImageScreen()), // Class pour générer une image via l'api
                );
              },
              icon: Icon(Icons.image, color: Colors.red), // Icône de l'image en rouge
              label: Text(
                'Générer une image', // Texte du bouton pour générer une image
                style: TextStyle(color: Colors.red), // Couleur du texte en rouge
              ),
            ),
            SizedBox(height: 80), // Espacement vertical
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImportedPictureScreen()), // Class pour importer ou prendre une photo depuis l'apareil
                );
              },
              icon: Icon(Icons.photo, color: Colors.green), // Icône de la photo en vert
              label: Text(
                'Utiliser mes images', // Texte du bouton pour utiliser mes images
                style: TextStyle(color: Colors.green), // Couleur du texte en vert
              ),
            ),
          ],
        ),
      ),
    );
  }
}

