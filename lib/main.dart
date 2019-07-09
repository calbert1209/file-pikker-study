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
        body: Container(
          color: Colors.grey,
          height: 300,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _localFile != null
                    ? Container(
                  child: Image.file(_localFile),

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
                right: 20,
                bottom: 20,
                child: IconButton(
                  icon: Icon(
                    Icons.edit,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: _openFileExplorer,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
