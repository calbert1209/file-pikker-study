import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(FilePickerDemo());

class FilePickerDemo extends StatefulWidget {
  @override
  _FilePickerDemoState createState() => _FilePickerDemoState();
}

class _FilePickerDemoState extends State<FilePickerDemo> {
  File _localFile;
  String _extension;
  FileType _pickingType = FileType.IMAGE;
  TextEditingController _controller = TextEditingController();
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  Future<String> get _appDocDirPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _nextLocalFile async {
    final path = await _appDocDirPath;
    return File('$path/image-${++_counter}.jpg');
  }

  Future<File> copyFileToLocal(String sourceFilePath) async {
    var destFile = await _nextLocalFile;
    var byteData = await File(sourceFilePath).readAsBytes();
    return destFile.writeAsBytes(byteData, mode: FileMode.write, flush: true);
  }

  void _openFileExplorer() async {
    String destFilePath;
    try {
      var sourceFilePath = await FilePicker.getFilePath(
          type: _pickingType, fileExtension: _extension);

      if (_localFile != null) {
        if (await _localFile.exists()) {
          await _localFile.delete();
          _localFile = null;
        }
      }

      var destFile = await _nextLocalFile;
      var byteData = await File(sourceFilePath).readAsBytes();
      await destFile.writeAsBytes(byteData, mode: FileMode.write, flush: true);
      destFilePath = destFile.path;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } on Exception catch (e) {
      print("Exception" + e.toString());
    }

    setState(() {
      _localFile = File(destFilePath);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('File Picker example app'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                    child: RaisedButton(
                      onPressed: _openFileExplorer,
                      child: Text("Open file picker"),
                    ),
                  ),
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      Container(
                        child: _localFile != null
                            ? Image.file(_localFile)
                            : Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey,
                              ),
                      ),
                      Padding(
                        child: Text(
                          'What the fuck?!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                          ),
                        ),
                        padding: EdgeInsets.all(10.0),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
