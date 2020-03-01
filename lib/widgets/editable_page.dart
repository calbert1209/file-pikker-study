import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_pikker/widgets/editable_label.dart';
import 'package:uuid/uuid.dart';

class EditablePage extends StatelessWidget {
  final void Function() _onFilePickerCalled;
  final void Function(String) _onLabelUpdated;
  final File _file;
  final int _index;
  final String _label;

  EditablePage({
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
    print(_file?.path ?? "file is null");
    var deviceData = MediaQuery.of(context);
    final backColor = Colors.blue[100 + (100 * _index)];
    return Container(
      color: backColor,
      height: deviceData.size.width,
      child: Stack(
        fit: StackFit.loose,
        children: <Widget>[
          Container(
              key: Key(_file?.path ?? Uuid().v1()),
              width: deviceData.size.width,
              height: deviceData.size.height,
              decoration: _file != null
                  ? BoxDecoration(
                      image: DecorationImage(
                        alignment: Alignment.topCenter,
                        fit: BoxFit.fitWidth,
                        // TODO use completer to listen for image load
                        // use future builder to await completer's future
                        // and display waiting and completed UI, etc.
                        // HINT: https://stackoverflow.com/a/44683714
                        image: FileImage(_file),
                      ),
                    )
                  : BoxDecoration()),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30.0),
              color: backColor.withAlpha(100),
              child: EditableLabel(
                initialLabel: _label,
                onUpdated: _onLabelUpdated,
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: ImageOverlayIconButton(
              icon: Icons.image,
              onFilePickerCalled: _onFilePickerCalled,
            ),
          )
        ],
      ),
    );
  }
}

class ImageOverlayIconButton extends StatelessWidget {
  const ImageOverlayIconButton({
    Key key,
    @required void Function() onFilePickerCalled,
    @required icon,
  })  : _onFilePickerCalled = onFilePickerCalled,
        _icon = icon,
        super(key: key);

  final void Function() _onFilePickerCalled;
  final IconData _icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      alignment: Alignment.topRight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.0, 0.49],
          colors: [
            Color.fromRGBO(0, 0, 0, 0.1),
            Color.fromRGBO(0, 0, 0, 0.0),
          ],
        ),
      ),
      child: IconButton(
        icon: Icon(
          _icon,
          color: Colors.white,
        ),
        onPressed: _onFilePickerCalled,
      ),
    );
  }
}
