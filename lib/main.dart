import 'dart:io';

import 'package:file_pikker/widgets/editable_label.dart';
import 'package:flutter/material.dart';
import './services/image_picker.dart';

void main() => runApp(FilePickerDemo());

class FilePickerDemo extends StatefulWidget {
  @override
  _FilePickerDemoState createState() => _FilePickerDemoState();
}

class _FilePickerDemoState extends State<FilePickerDemo> {
  List<File> _localFiles = new List<File>.filled(3, null, growable: false);
  List<String> _labels = ["item 0", "item 1", "item 2"];
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

    setState(() {
      print(destFile.path);
      _localFiles[index] = destFile;
    });
  }

  void _updateLabelStore(int index, String label) {
    setState(() {
      print("updating label at index $index to $label");
      _labels[index] = label;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('File Picker example app'),
        ),
        body: PageView(
          controller: _pageController,
          children: [0, 1, 2].map((item) {
            return PageViewPage(
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

class PageViewPage extends StatelessWidget {
  final void Function() _onFilePickerCalled;
  final void Function(String) _onLabelUpdated;
  final File _file;
  final int _index;
  final String _label;

  PageViewPage({
    Key key,
    int index,
    void Function() onFilePickerCalled,
    void Function(String) onLabelUpdated,
    File file,
    String label,
  })  : _onFilePickerCalled = onFilePickerCalled,
        _onLabelUpdated = onLabelUpdated,
        _file = file,
        _index = index,
        _label = label,
        assert(label != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(_label != null);
    return Container(
      color: Colors.blue[100 + (100 * _index)],
      height: 480,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _file != null
                ? Container(
                    key: Key(_file.path),
                    child: Image.file(_file),
                  )
                : Container(),
          ),
          Positioned(
            left: 0,
            bottom: 30,
            child: EditableLabel(
              initialLabel: _label,
              onUpdated: _onLabelUpdated,
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 100.0,
              height: 100.0,
              alignment: Alignment.topRight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [0.0, 0.1, 0.2, 0.3, 0.4, 0.5],
                  colors: [
                    Color.fromRGBO(0, 0, 0, 0.15),
                    Color.fromRGBO(0, 0, 0, 0.1),
                    Color.fromRGBO(0, 0, 0, 0.075),
                    Color.fromRGBO(0, 0, 0, 0.05),
                    Color.fromRGBO(0, 0, 0, 0.025),
                    Color.fromRGBO(0, 0, 0, 0.0),
                  ],
                ),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.image,
                  size: 20,
                  color: Colors.white,
                ),
                onPressed: _onFilePickerCalled,
              ),
            ),
          )
        ],
      ),
    );
  }
}
