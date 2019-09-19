import 'dart:io';

import 'package:flutter/material.dart';
import './services/image_picker.dart';

void main() => runApp(FilePickerDemo());

class FilePickerDemo extends StatefulWidget {
  @override
  _FilePickerDemoState createState() => _FilePickerDemoState();
}

class _FilePickerDemoState extends State<FilePickerDemo> {
  File _localFile;
  ImagePicker _imagePicker = ImagePicker();

  Future<void> _openFileExplorer() async {
    File destFile = await _imagePicker.getPickedImage();

    setState(() {
      _localFile = destFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('File Picker example app'),
        ),
        body: Column(
          children: <Widget>[
            PageViewPage(
              key: Key(_localFile.path),
              onFilePickerCalled: () async {
                await _openFileExplorer();
              },
              file: _localFile,
            ),
          ],
        ),
      ),
    );
  }
}

class PageViewPage extends StatelessWidget {
  final void Function() _onFilePickerCalled;
  final File _file;

  PageViewPage({void Function () onFilePickerCalled, File file, Key key})
    : _onFilePickerCalled = onFilePickerCalled,
      _file = file,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
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
              color: Colors.grey,
              height: 300,
            ),
          ),
          Positioned(
            left: 30,
            bottom: 30,
            child: Center(
              child: Text(
                'target language',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
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
