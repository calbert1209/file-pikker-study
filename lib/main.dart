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
                  file: _localFiles[item]);
            }).toList()),
      ),
    );
  }
}

class PageViewPage extends StatelessWidget {
  final void Function() _onFilePickerCalled;
  final File _file;
  final int _index;

  PageViewPage(
      {void Function() onFilePickerCalled, File file, Key key, int index})
      : _onFilePickerCalled = onFilePickerCalled,
        _file = file,
        _index = index,
        super(key: key);

  @override
  Widget build(BuildContext context) {
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
                : Container(
//                    color: Colors.grey,
                    height: 300,
                  ),
          ),
          Positioned(
            left: 0,
            bottom: 30,
            child: EditableLabel(
              initialLabel: 'Item $_index',
            ),
//            child: Center(
//              child: Text(
//                'Item $_index',
//                style: TextStyle(
//                  fontSize: 24,
//                  fontWeight: FontWeight.w400,
//                  color: Colors.white,
//                ),
//              ),
//            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              icon: Icon(
                Icons.settings,
                size: 20,
                color: Colors.white,
              ),
              onPressed: _onFilePickerCalled,
            ),
          )
        ],
      ),
    );
  }
}
