import 'package:flutter/material.dart';

class EditableLabel extends StatefulWidget {
  final String _initialLabel;
  final void Function(String) _onUpdated;

  EditableLabel({
    Key key,
    @required String initialLabel,
    @required onUpdated,
  })  : _initialLabel = initialLabel,
        _onUpdated = onUpdated,
        super(key: key);

  @override
  _EditableLabelState createState() => _EditableLabelState(_initialLabel);
}

class _EditableLabelState extends State<EditableLabel> {
  bool _isEditing;
  String _labelValue;
  TextEditingController _controller;

  _EditableLabelState(this._labelValue);

  @override
  void initState() {
    _isEditing = false;
    _controller = TextEditingController();
    super.initState();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void startEditMode() {
    setState(() {
      _isEditing = true;
      _controller.text = _labelValue;
    });
  }

  void saveInput() {
    setState(() {
      _isEditing = false;
      var text = _controller.text;
      if (text.length > 0) {
        widget._onUpdated(_controller.value.text);
        _labelValue = _controller.value.text;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        IconButton(
          icon: Icon(
            _isEditing ? Icons.check : Icons.edit,
            size: 20.0,
            color: Colors.white,
          ),
          onPressed: _isEditing ? saveInput : startEditMode,
        ),
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: 100.0, maxWidth: 300.0),
          child: _isEditing
              ? TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(),
                )
              : Text(
                  _labelValue,
                  textAlign: TextAlign.start,
                ),
        ),
      ],
    );
  }
}
