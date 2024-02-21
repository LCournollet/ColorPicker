import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pick_color/pick_color.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ImportedPictureScreen extends StatefulWidget {
  @override
  _ImportedPictureScreenState createState() => _ImportedPictureScreenState();
}

class _ImportedPictureScreenState extends State<ImportedPictureScreen> {
  Color? color;
  PickerResponse? userResponse;
  bool _showRectangle = false;
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Hex code copied to clipboard'),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await _imagePicker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
        _showRectangle = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Import or take a picture'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        backgroundColor: Color(0xFFCFF0FF),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (_selectedImage != null)
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.1,
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
                        _showRectangle = true;
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
                      showMarker: false,
                      onChanged: (response) {
                        setState(() {
                          userResponse = response;
                          this.color = response.selectionColor;
                          _showRectangle = true;
                        });
                      },
                    ),
                  ),
                  if (_showRectangle && userResponse != null)
                    Positioned(
                      left: userResponse!.xpostion+5,
                      top: userResponse!.ypostion-25,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: userResponse!.selectionColor,
                        ),
                      ),
                    ),
                  if (_showRectangle)
                    Positioned(
                      bottom: 20,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey[200],
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
                                    "Selected Color:",
                                    style: TextStyle(
                                      color: Colors.blue, // Change la couleur du texte en bleu
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
                                    "Hex Code: ${userResponse?.hexCode ?? "-"}",
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
                        icon: Icon(Icons.image, color: Colors.blue), // Change la couleur de l'icône en bleu
                        label: Text(
                          'Import Picture',
                          style: TextStyle(color: Colors.blue), // Change la couleur du texte en bleu
                        ),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.camera),
                        icon: Icon(Icons.camera_alt, color: Colors.blue), // Change la couleur de l'icône en bleu
                        label: Text(
                          'Take Picture',
                          style: TextStyle(color: Colors.blue), // Change la couleur du texte en bleu
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
