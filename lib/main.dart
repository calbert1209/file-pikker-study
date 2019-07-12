import 'dart:io';

import 'package:flutter/material.dart';
import './services/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() => runApp(FilePickerDemo());

class FilePickerDemo extends StatefulWidget {
  @override
  _FilePickerDemoState createState() => _FilePickerDemoState();
}

class _FilePickerDemoState extends State<FilePickerDemo> {
  File _localFile;
  ImagePicker _imagePicker = ImagePicker();

  void _openFileExplorer() async {
    String destFilePath = await _imagePicker.getPickedImagePath();

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
        body: Column(
          children: <Widget>[
            Container(
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
                    right: 0,
                    top: 0,
                    child: IconButton(
                      icon: Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.white,
                      ),
                      onPressed: _openFileExplorer,
                    ),
                  )
                ],
              ),
            ),
            CarouselSlider(
              height: 300.0,
              items: [1,2,3,4,5].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO((30 * i) + 50, 0, 0, 1),
                      ),
                      child: Align(
                        alignment: Alignment(-0.5,-0.5),
                        child: Text(
                            'text $i',
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                            )
                        ),
                      )
                    );
                  },
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
