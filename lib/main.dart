import 'dart:io';
import 'package:file_pikker/widgets/editable_page.dart';
import 'package:flutter/material.dart';
import './services/image_picker.dart';

void main() => runApp(FilePickerDemo());

class FilePickerDemo extends StatefulWidget {
  @override
  _FilePickerDemoState createState() => _FilePickerDemoState();
}

class _FilePickerDemoState extends State<FilePickerDemo> {
  // TODO store file in consumed form (ImageFile) to prevent lag on page flip?
  List<File> _localFiles = new List<File>.filled(5, null, growable: false);
  List<String> _labels = ["item 0", "item 1", "item 2", "item 3", "item 4"];
  ImagePicker _imagePicker;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
    _pageController = PageController(
      initialPage: 0,
    );
  }

  Future<void> _openFileExplorer(int index) async {
    File destFile = await _imagePicker.getPickedImage();
    if (destFile == null) {
      return;
    }

    setState(() {
      debugPrint(destFile.path);
      _localFiles[index] = destFile;
    });
  }

  void _updateLabelStore(int index, String label) {
    setState(() {
      debugPrint("updating label at index $index to $label");
      _labels[index] = label;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('kuusisataa'),
        ),
        body: PageView(
          controller: _pageController,
          children: [0, 1, 2, 3, 4].map((item) {
            return EditablePage(
              index: item,
              key: Key('$item'),
              onFilePickerCalled: () async {
                await _openFileExplorer(item);
              },
              onLabelUpdated: (String label) {
                _updateLabelStore(item, label);
              },
              file: _localFiles[item],
              label: _labels[item],
            );
          }).toList(),
        ),
      ),
    );
  }
}
