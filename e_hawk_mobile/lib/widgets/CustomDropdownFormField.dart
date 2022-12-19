import 'package:e_hawk_mobile/utilities/Global.dart';
import 'package:flutter/material.dart';

typedef OnChangeCallback = void Function(String index, dynamic value);

class CustomDropdownFormField extends StatefulWidget {
  final TextStyle textStyle;
  final String style;
  final String label;
  final Color textColor;
  final Color dropdownColor;
  final Color fieldColor;
  final Color? borderColor;
  final bool useBorder;
  final Icon? icon;
  final bool loadState;
  final bool required;
  final Map<String, dynamic> listable; //map of selectable data
  final Map<String, dynamic> writable;
  final String writableIndex; //map to write selected data
  final OnChangeCallback onChanged;

  const CustomDropdownFormField(
      {Key? key,
      required this.listable,
      required this.writable,
      required this.writableIndex,
      required this.onChanged,
      this.required = false,
      this.label = "",
      this.style = Global.ddown_style_ulined,
      this.textStyle = Global.genericText,
      this.textColor = Colors.black,
      this.fieldColor = Colors.white,
      this.borderColor,
      this.useBorder = true,
      this.icon,
      this.dropdownColor = Colors.white,
      required this.loadState})
      : super(key: key);

  @override
  _CustomDropdownFormFieldState createState() =>
      _CustomDropdownFormFieldState();
}

class _CustomDropdownFormFieldState extends State<CustomDropdownFormField> {
  Map<String, dynamic>? listable;
  dynamic value;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      icon: widget.icon ?? Icon(Icons.arrow_drop_down, color: widget.textColor),
      iconSize: 24,
      dropdownColor: widget.dropdownColor,
      decoration: InputDecoration(
          // contentPadding: widget.style == Global.ddown_style_ulined
          //       ? const EdgeInsets.only(left: 10, bottom: 10)
          //       : EdgeInsets.only(
          //           top: widget.style == Global.ddown_style_pill ? 30 : 20,
          //           left: 20,
          //           right: 20),
          labelText: widget.label,
          errorBorder: widget.style == Global.ddown_style_ulined
              ? UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: widget.useBorder
                          ? Colors.transparent
                          : Global.primary))
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                      color: widget.useBorder
                          ? Colors.transparent
                          : Global.primary)),
          focusedErrorBorder: widget.style == Global.ddown_style_ulined
              ? UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: widget.useBorder
                          ? Colors.transparent
                          : Global.primary))
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                      color: widget.useBorder
                          ? Colors.transparent
                          : Global.primary)),
          focusedBorder: widget.style == Global.ddown_style_ulined
              ? UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: widget.useBorder
                          ? Colors.transparent
                          : Global.primary))
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                      color: widget.useBorder
                          ? Colors.transparent
                          : Global.primary)),
          disabledBorder: widget.style == Global.ddown_style_ulined
              ? UnderlineInputBorder(
                  borderSide: BorderSide(color: Global.disabledText!))
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Global.disabledText!)),
          enabledBorder: widget.style == Global.ddown_style_ulined
              ? UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: widget.useBorder
                          ? Colors.transparent
                          : widget.borderColor ?? widget.textColor))
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                      color: widget.useBorder
                          ? Colors.transparent
                          : widget.borderColor ?? widget.textColor)),
          border: widget.style == Global.ddown_style_ulined
              ? UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: widget.useBorder
                          ? Colors.transparent
                          : widget.borderColor ?? widget.textColor))
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                      color: widget.useBorder
                          ? Colors.transparent
                          : widget.borderColor ?? widget.textColor)),
          labelStyle: widget.textStyle,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          fillColor: widget.style == Global.ddown_style_ulined
              ? Colors.transparent
              : Colors.white),
      disabledHint: Text(
          widget.loadState
              ? ''
              : widget.listable[widget.writable[widget.writableIndex]],
          style: Global.genericText.apply(color: Global.disabledText)),
      value: widget.loadState ? null : '0',
      onChanged: (val) => widget.onChanged(widget.writableIndex, val),
      items: widget.listable
          .map((id, value) {
            return MapEntry(
                id,
                DropdownMenuItem(
                    value: id,
                    child: SizedBox(
                        width: 250,
                        child: Text(
                          id == '0'
                              ? widget.required
                                  ? widget.label + " *"
                                  : widget.label
                              : value,
                          overflow: TextOverflow.fade,
                          style:
                              Global.genericText.apply(color: widget.textColor),
                        ))));
          })
          .values
          .toList(),
    );
  }
}
