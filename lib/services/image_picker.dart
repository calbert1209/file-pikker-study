import 'dart:io';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImagePicker {

  final FileType _pickingType = FileType.IMAGE;
  File _localFile;
  int _counter = 0;

  Future<String> get _appDocDirPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _nextLocalFile async {
    final path = await _appDocDirPath;
    return File('$path/image-${++_counter}.jpg');
  }

  Future<String> getPickedImagePath() async {
    String destFilePath;
    try {
      var sourceFilePath = await FilePicker.getFilePath(type: _pickingType);

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
    return destFilePath;
  }
}