import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyColorsPage extends StatefulWidget {
  const MyColorsPage({Key? key}) : super(key: key);

  @override
  _MyColorsPageState createState() => _MyColorsPageState();
}

class _MyColorsPageState extends State<MyColorsPage> {
  late List<Color> _copiedColors;
  late List<String> _copiedColorHexStrings;

  @override
  void initState() {
    super.initState();
    _copiedColors = [];
    _copiedColorHexStrings = [];
    _loadCopiedColors();
  }

  void _loadCopiedColors() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? copiedColors = prefs.getStringList('copied_colors');
    if (copiedColors != null) {
      setState(() {
        _copiedColors =
            copiedColors.map((value) => Color(int.parse(value))).toList();
        _copiedColorHexStrings =
            _copiedColors.map((color) => '#${color.value.toRadixString(16)
                .substring(2)}').toList();
      });
    }
  }

  void _clearSavedColors() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('copied_colors');
    setState(() {
      _copiedColors = [];
      _copiedColorHexStrings = [];
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Saved colors cleared')),
    );
  }

  void _removeColor(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? copiedColors = prefs.getStringList('copied_colors');
    if (copiedColors != null) {
      copiedColors.removeAt(index);
      await prefs.setStringList('copied_colors', copiedColors);
      _loadCopiedColors();
    }
  }

  void _copyColorHexToClipboard(String hexString) {
    Clipboard.setData(ClipboardData(text: hexString));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Hexadecimal code copied: $hexString')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Colors'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _clearSavedColors,
            color: Colors.white,
          ),
        ],
      ),
      body: Center(
        child: _copiedColors
            .isEmpty // Vérifie si la liste des couleurs copiées est vide
            ? Text(
          'No color copied yet',
          style: TextStyle(fontSize: 20),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                'Last Copied Colors',
                style: TextStyle(fontSize: 22),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _copiedColors.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: 300,
                          height: 100,
                          color: _copiedColors[index],
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _copyColorHexToClipboard(
                                  _copiedColorHexStrings[index]);
                            },
                            child: Text(
                              _copiedColorHexStrings[index],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.content_copy),
                            onPressed: () {
                              _copyColorHexToClipboard(
                                  _copiedColorHexStrings[index]);
                            },
                            color: Colors.blue,
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _removeColor(index);
                            },
                            color: Colors.red,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}