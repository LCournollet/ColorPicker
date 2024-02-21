// Page pour générer une image via l'api

import 'package:flutter/material.dart';
import 'package:pick_color/pick_color.dart';
import 'package:color_picker/app/api/api.dart';
import 'package:flutter/services.dart'; // Importation du package flutter/services.dart pour accéder à la fonctionnalité du presse-papiers
import 'package:unsplash_client/unsplash_client.dart'; // Importation du package unsplash_client

class GenerateImageScreen extends StatefulWidget {
  @override
  _GenerateImageScreenState createState() => _GenerateImageScreenState();
}

class _GenerateImageScreenState extends State<GenerateImageScreen> {
  late Future<Photo> _photoFuture;
  Color? color;
  PickerResponse? userResponse;
  bool _showRectangle = false;

  @override
  void initState() {
    super.initState();
    // Chargement de l'image initiale
    _photoFuture = _fetchSinglePhoto();
    // Initialisation de userResponse à null
    userResponse = null;
  }

  Future<Photo> _fetchSinglePhoto() async {
    // Récupération d'une seule photo
    return await fetchSinglePhoto();
  }

  void _generateNewImage() {
    // Génération d'une nouvelle image
    setState(() {
      _photoFuture = _fetchSinglePhoto();
      // Réinitialisation de userResponse à null lors de la génération d'une nouvelle image
      userResponse = null;
      _showRectangle = false; // Masquer le rectangle lors de la génération d'une nouvelle image
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)); // Copie du texte dans le presse-papiers
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Code hexadécimal copié dans le presse-papiers'), // Affichage du message de confirmation
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Générer une image'), // Titre
          centerTitle: true, // Centrer le titre dans le header
          backgroundColor: Colors.blue, // Couleur de fond du header
        ),
        backgroundColor: Color(0xFFCFF0FF), // Couleur de fond
        body: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  FutureBuilder<Photo>(
                    future: _photoFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Affichage d'un indicateur de chargement pendant le chargement de l'image (bugé car la génération de l'image lag)
                        return CircularProgressIndicator(
                          color: Colors.black,
                        );
                      } else if (snapshot.hasError) {
                        // Erreur de requètes
                        return Center(
                          child: Text('Erreur: ${snapshot.error}'),
                        );
                      } else if (!snapshot.hasData) {
                        // Erreur de l'api (banque innaccessible souvent)
                        return Center(
                          child: Text('Aucune donnée d\'image disponible'),
                        );
                      } else {
                        final photo = snapshot.data!;
                        final resizedUrl = "${photo.urls.raw}&w=800&h=800";
                        return ColorPicker(
                          child: Image.network(resizedUrl),
                          showMarker: false,
                          onChanged: (response) {
                            setState(() {
                              userResponse = response;
                              color = response.selectionColor;
                              _showRectangle = true; // Afficher le rectangle lorsqu'une couleur est sélectionnée
                            });
                          },
                        );
                      }
                    },
                  ),
                  if (_showRectangle) // Afficher le rectangle uniquement lorsqu'une couleur est sélectionnée
                    Positioned(
                      bottom: 20,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey[200], // Couleur de fond gris du rectangle
                        ),
                        child: InkWell(
                          onTap: () {
                            if (userResponse != null) {
                              _copyToClipboard(userResponse!.hexCode);
                            }
                          },
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Couleur sélectionnée:", // Texte indiquant la couleur sélectionnée
                                    style: TextStyle(
                                      color: Colors.black,
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
                                    "Code Hex: ${userResponse?.hexCode ?? "-"}", // Code Hexadécimal
                                    style: TextStyle(
                                      color: userResponse != null ? Colors.black : Colors.grey,
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
              padding: const EdgeInsets.all(20), // Bouton de génération d'une nouvelle image
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    onPressed: _generateNewImage,
                    tooltip: 'Générer une nouvelle image',
                    child: Icon(Icons.refresh),
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
