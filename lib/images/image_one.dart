import 'package:flutter/material.dart';
import 'package:pick_color/pick_color.dart';
import 'package:color_picker/api/api.dart';
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
  bool _showRectangle = false;

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
      _showRectangle = false; // Hide the rectangle when generating a new image
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
          title: Text(
            'Pick a color on the picture',
            style: TextStyle(
              fontSize: 20.0,
              fontFamily: "SpaceGroteskBold",
            ),
          ),
          centerTitle: true,
        ),
        body: Stack(
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
                  final resizedUrl = "${photo.urls.raw}&w=400&h=400";
                  return ColorPicker(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20.0), // Ajustez la valeur selon vos besoins
                      child: Image.network(resizedUrl),
                    ),
                    showMarker: true,
                    onChanged: (response) {
                      setState(() {
                        userResponse = response;
                        this.color = response.selectionColor;
                        _showRectangle = true; // Afficher le rectangle lorsque une couleur est sélectionnée
                      });
                    },
                  );
                }
              },
            ),
            if (_showRectangle) // Display the rectangle only when a color is selected
              Positioned(
                bottom: 20,
                child: Container(
                  color: Colors.grey[200],
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                              color: userResponse != null ? userResponse!
                                  .selectionColor : Colors.transparent,
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Hex Code: ${userResponse?.hexCode ?? "-"}",
                        style: TextStyle(
                          color: userResponse != null ? Colors.black : Colors
                              .grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _generateNewImage,
          tooltip: 'Generate New Image',
          child: Icon(Icons.refresh),
        ),
      ),
    );
  }
}