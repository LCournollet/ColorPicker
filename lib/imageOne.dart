import 'package:flutter/material.dart';
import 'package:pick_color/pick_color.dart';
import 'package:color_picker/api.dart';
import 'package:flutter/services.dart'; // Import the flutter/services.dart package for accessing clipboard functionality
import 'package:unsplash_client/unsplash_client.dart'; // Import the unsplash_client package

class ImagePickerScreen extends StatefulWidget {
  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  late Future<Photo> _photoFuture;
  Color? color;
  PickerResponse? userResponse;

  @override
  void initState() {
    super.initState();
    // Load initial image
    _photoFuture = _fetchSinglePhoto();
    // Initialize userResponse to null
    userResponse = null;
  }

  Future<Photo> _fetchSinglePhoto() async {
    // Fetch a single photo
    return await fetchSinglePhoto();
  }

  void _generateNewImage() {
    // Generate a new image
    setState(() {
      _photoFuture = _fetchSinglePhoto();
      // Reset userResponse to null when generating a new image
      userResponse = null;
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)); // Copy text to clipboard
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Hex code copied to clipboard'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Image Picker'),
          backgroundColor: userResponse?.selectionColor ?? Colors.blue, // Change the app bar color based on selected color
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
                  FutureBuilder<Photo>(
                    future: _photoFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Display a loading indicator while fetching the image
                        return CircularProgressIndicator(
                          color: Colors.black,
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (!snapshot.hasData) {
                        return Center(
                          child: Text('No photo data available'),
                        );
                      } else {
                        final photo = snapshot.data!;
                        final resizedUrl = "${photo.urls.raw}&w=800&h=800";
                        return ColorPicker(
                          child: Image.network(resizedUrl),
                          showMarker: true,
                          onChanged: (response) {
                            setState(() {
                              userResponse = response;
                              this.color = response.selectionColor;
                            });
                          },
                        );
                      }
                    },
                  ),
                  if (userResponse == null)
                    CircularProgressIndicator(
                      color: Colors.black,
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    onPressed: _generateNewImage,
                    tooltip: 'Generate New Image',
                    child: Icon(Icons.refresh),
                  ),
                  SizedBox(width: 20),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
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
                        TextButton(
                          onPressed: () {
                            if (userResponse != null) {
                              _copyToClipboard(userResponse!.hexCode);
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Hex Code: ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                userResponse?.hexCode ?? "-",
                                style: TextStyle(
                                  color: userResponse != null ? userResponse!.selectionColor : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
