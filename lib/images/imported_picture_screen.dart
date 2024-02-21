// Page pour importer ou prendre une photo

import 'dart:io'; // Importation de la bibliothèque permettant de travailler avec les fichiers

import 'package:flutter/material.dart'; // Importation du package Flutter Material
import 'package:pick_color/pick_color.dart'; // Importation du package pour le sélecteur de couleur
import 'package:flutter/services.dart'; // Importation du package flutter/services.dart pour accéder à la fonctionnalité du presse-papiers
import 'package:image_picker/image_picker.dart'; // Importation du package pour choisir des images depuis le périphérique

class ImportedPictureScreen extends StatefulWidget {
  @override
  _ImportedPictureScreenState createState() => _ImportedPictureScreenState();
}

class _ImportedPictureScreenState extends State<ImportedPictureScreen> {
  Color? color; // Couleur sélectionnée
  PickerResponse? userResponse; // Réponse de l'utilisateur lors de la sélection de couleur
  bool _showRectangle = false; // Variable pour afficher ou masquer le rectangle de couleur
  final ImagePicker _imagePicker = ImagePicker(); // Instance de la classe ImagePicker pour choisir des images
  File? _selectedImage; // Fichier de l'image sélectionnée

  // Fonction pour copier le code hexadécimal de la couleur dans le presse-papiers
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)); // Copie du texte dans le presse-papiers
    ScaffoldMessenger.of(context).showSnackBar( // Affichage d'un SnackBar pour indiquer que le code a été copié
      SnackBar(
        content: Text('Code hexadécimal copié dans le presse-papiers'),
      ),
    );
  }

  // Fonction pour choisir une image depuis la galerie ou l'appareil photo
  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await _imagePicker.pickImage(source: source); // Sélection de l'image
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path); // Assignation de l'image sélectionnée
        _showRectangle = false; // Réinitialisation de l'affichage du rectangle
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Importer ou prendre une photo'), // Titre de l'application dans la barre d'applications
          centerTitle: true, // Centrage du titre
          backgroundColor: Colors.blue, // Couleur de fond de la barre d'applications
        ),
        backgroundColor: Color(0xFFCFF0FF), // Couleur de fond de l'écran
        body: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (_selectedImage != null) // Affichage de l'image sélectionnée si elle existe
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.1, // Positionnement de l'image au milieu de l'écran
                      child: Image.file(
                        _selectedImage!,
                        width: 800,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showRectangle = true; // Affichage du rectangle de sélection de couleur au toucher de l'écran
                      });
                    },
                    child: ColorPicker(
                      child: Container(
                        width: 800,
                        height: 800,
                        decoration: BoxDecoration(
                          image: _selectedImage != null
                              ? DecorationImage(
                                  image: FileImage(_selectedImage!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                      ),
                      showMarker: false, // Désactivation du marqueur de sélection de couleur
                      onChanged: (response) {
                        setState(() {
                          userResponse = response; // Attribution de la réponse de l'utilisateur
                          this.color = response.selectionColor; // Attribution de la couleur sélectionnée
                          _showRectangle = true; // Affichage du rectangle de sélection de couleur
                        });
                      },
                    ),
                  ),
                  if (_showRectangle && userResponse != null) // Affichage du rectangle de couleur sélectionnée
                    Positioned(
                      left: userResponse!.xpostion + 5, // Positionnement horizontal du rectangle
                      top: userResponse!.ypostion - 25, // Positionnement vertical du rectangle
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: userResponse!.selectionColor, // Couleur du cercle dans le rectangle
                        ),
                      ),
                    ),
                  if (_showRectangle) // Affichage du rectangle avec la couleur sélectionnée et le code hexadécimal correspondant
                    Positioned(
                      bottom: 20,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey[200], // Couleur de fond du rectangle
                        ),
                        child: InkWell(
                          onTap: () {
                            if (userResponse != null) {
                              _copyToClipboard(userResponse!.hexCode); // Copie du code hexadécimal dans le presse-papiers
                            }
                          },
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Couleur sélectionnée:", // Libellé indiquant la couleur sélectionnée
                                    style: TextStyle(
                                      color: Colors.blue, // Couleur du texte en bleu
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: userResponse != null ? userResponse!.selectionColor : Colors.transparent,
                                      border: Border.all(color: Colors.black, width: 1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Code Hex: ${userResponse?.hexCode ?? "-"}", // Affichage du code hexadécimal de la couleur sélectionnée
                                    style: TextStyle(
                                      color: userResponse != null ? Colors.blue : Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        icon: Icon(Icons.image, color: Colors.blue), // Icône pour importer une image depuis la galerie
                        label: Text(
                          'Importer une photo',
                          style: TextStyle(color: Colors.blue), // Texte avec la couleur bleue
                        ),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.camera),
                        icon: Icon(Icons.camera_alt, color: Colors.blue), // Icône pour prendre une photo avec l'appareil photo
                        label: Text(
                          'Prendre une photo',
                          style: TextStyle(color: Colors.blue), // Texte avec la couleur bleue
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

