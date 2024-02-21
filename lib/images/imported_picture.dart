import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pick_color/pick_color.dart';
import 'package:flutter/services.dart'; // Import the flutter/services.dart package for accessing clipboard functionality
import 'package:image_picker/image_picker.dart'; // Import the image_picker package for picking images from the device

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
    Clipboard.setData(ClipboardData(text: text)); // Copy text to clipboard
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
        // Set the selected image file
        _selectedImage = File(pickedImage.path);
        _showRectangle = false; // Reset the rectangle display when a new image is picked
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Imported Picture'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (_selectedImage != null) // Display selected image if available
                    Image.file(
                      _selectedImage!,
                      width: 800,
                      height: 800,
                      fit: BoxFit.cover,
                    ),
                  ColorPicker(
                    child: _selectedImage != null
                        ? Image.file(
                      _selectedImage!,
                      width: 800,
                      height: 800,
                      fit: BoxFit.cover,
                    )
                        : Image.network('https://via.placeholder.com/800x800'), // Placeholder image
                    showMarker: true,
                    onChanged: (response) {
                      setState(() {
                        userResponse = response;
                        this.color = response.selectionColor;
                        _showRectangle = true; // Show the rectangle when a color is selected
                      });
                    },
                  ),
                  if (_showRectangle) // Display the rectangle only when a color is selected
                    Positioned(
                      bottom: 20,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(5),
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
                                    "Hex Code: ${userResponse?.hexCode ?? "-"}",
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
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        child: Text('Import Picture'),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () => _pickImage(ImageSource.camera),
                        child: Text('Take Picture'),
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
