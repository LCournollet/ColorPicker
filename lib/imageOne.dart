import 'package:flutter/material.dart';
import 'package:pick_color/pick_color.dart';
import 'package:color_picker/api.dart';
import 'package:unsplash_client/unsplash_client.dart';

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
    _photoFuture = fetchSinglePhoto();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<Photo>(
          future: _photoFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('No photo data available'));
            } else {
              final photo = snapshot.data!;
              final resizedUrl = "${photo.urls.raw}&w=400&h=400"; // Resize the image to 400x400
              return Column(
                children: [
                  ColorPicker(
                    child: Image.network(resizedUrl), // Use the resized image
                    showMarker: true,
                    onChanged: (response) {
                      setState(() {
                        userResponse = response;
                        this.color = response.selectionColor;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Selected Color:",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: userResponse?.selectionColor ?? Colors.red,
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Hex Code: ${userResponse?.hexCode ?? ""}",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
