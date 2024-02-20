import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseColorsPage extends StatefulWidget {
  const ChooseColorsPage({Key? key}) : super(key: key);

  @override
  _ChooseColorsPageState createState() => _ChooseColorsPageState();
}

class _ChooseColorsPageState extends State<ChooseColorsPage> {
  late Color _selectedColor;
  late String _hexString;

  @override
  void initState() {
    super.initState();
    _loadSelectedColor();
  }

  // Fonction pour sauvegarder la couleur sélectionnée dans SharedPreferences
  void _saveSelectedColor(Color color) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selected_color', color.value);
  }

  // Fonction pour charger la couleur sauvegardée dans SharedPreferences
  void _loadSelectedColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int colorValue = prefs.getInt('selected_color') ?? Colors.purple.value;
    setState(() {
      _selectedColor = Color(colorValue);
      _updateHexString();
    });
  }

  // Fonction pour mettre à jour la valeur hexadécimale de la couleur sélectionnée
  void _updateHexString() {
    _hexString = '#${_selectedColor.value.toRadixString(16).substring(2)}';
  }

  // Fonction pour copier le code hexadécimal dans le presse-papiers
  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _hexString));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Hexadecimal code copied : $_hexString')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Choose a Color',
          style: TextStyle(
            fontSize: 20.0,
            fontFamily: "SpaceGroteskBold",
          ),
        ),
        backgroundColor: _selectedColor,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialColorPicker(
              selectedColor: _selectedColor,
              onColorChange: (color) {
                setState(() {
                  _selectedColor = color;
                  _updateHexString();
                  _saveSelectedColor(color);
                });
              },
              circleSize: 65.0,
              spacing: 25,
            ),
            SizedBox(height: 30),
            Text(
              'Selected Color:',
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'SpaceGroteskBold',
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 60,
              height: 70,
              decoration: BoxDecoration(
                color: _selectedColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
              ),
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'SpaceGroteskRegular',
                  color: Colors.black, // spécifiez la couleur si nécessaire
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Hexadecimal Code: ',
                  ),
                  TextSpan(
                    text: _hexString,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _selectedColor,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: _copyToClipboard,
              icon: Icon(Icons.content_copy),
              label: Text('Copy'),
            ),
          ],
        ),
      ),
    );
  }
}