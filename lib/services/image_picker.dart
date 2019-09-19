import 'dart:io';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ImagePicker {

  final FileType _pickingType = FileType.IMAGE;
  final _uuid = Uuid();
  File _localFile;
  int _counter = 0;

  Future<String> get _appDocDirPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _nextLocalFile async {
    final path = await _appDocDirPath;
    return File('$path/${_uuid.v1()}.jpg');
  }

  Future<File> getPickedImage() async {
    File destFile;
    try {
      var sourceFilePath = await FilePicker.getFilePath(type: _pickingType);

      if (_localFile != null) {
        if (await _localFile.exists()) {
          await _localFile.delete();
          _localFile = null;
        }
      }

      destFile = await _nextLocalFile;
      var byteData = await File(sourceFilePath).readAsBytes();
      await destFile.writeAsBytes(byteData, mode: FileMode.write, flush: true);
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } on Exception catch (e) {
      print("Exception" + e.toString());
    }
    return destFile;
  }
}