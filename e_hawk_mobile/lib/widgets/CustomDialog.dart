import 'package:e_hawk_mobile/utilities/Global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatefulWidget {
  CustomDialog(
      {Key? key, required this.label, required this.content, this.actions})
      : super(key: key);

  final String label;
  final dynamic content;
  final List<Widget>? actions;

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomDialog> {
  BuildContext? _ctx;
  bool isList = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    return AlertDialog(
      // titlePadding: Global.p_a(15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        widget.label,
        style: Global.titleText,
      ),
      content: widget.content is String
          ? Text(widget.content,
              style: Global.genericText, textAlign: TextAlign.center)
          : widget.content,
      actions: widget.actions ??
          [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Tidak')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Ya'))
          ],
    );
  }
}
