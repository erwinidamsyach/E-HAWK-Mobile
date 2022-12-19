import 'dart:ui' as ui;

import 'package:e_hawk_mobile/utilities/Global.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

typedef FunctionStringCallback = Function(String data);

class CustomTextFormField extends StatefulWidget {
  final String style;
  final String label;
  final ui.VoidCallback? onPressed;
  final FunctionStringCallback? onSubmit;
  final double radius;
  final Color? placeholderColor;
  final Color textColor;
  final Color? entryTextColor;
  final Color? fieldColor;
  final String? hint;
  final bool isPassword;
  final TextEditingController controller;
  final bool isTextArea;
  final int? maxLength;
  final bool isNumber;
  final bool isLocked;
  final bool required;
  final Color? borderColor;
  final Icon? suffixIcon;
  final EdgeInsets? padding;
  final FloatingLabelBehavior? flb;
  final double? tweenValue; //special parameter for Tween<double> value

  final bool enabled;

  const CustomTextFormField(
      {Key? key,
      required this.label,
      required this.controller,
      this.style = Global.tbox_style_pill,
      this.padding,
      this.suffixIcon,
      this.hint,
      this.radius = 15,
      this.placeholderColor,
      this.textColor = Colors.black,
      this.entryTextColor,
      this.fieldColor,
      this.onPressed,
      this.onSubmit,
      this.isPassword = false,
      this.isTextArea = false,
      this.isNumber = false,
      this.enabled = true,
      this.isLocked = false,
      this.required = false,
      this.maxLength,
      this.borderColor,
      this.flb,
      this.tweenValue})
      : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool isPwdVisible = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isPassword = widget.isPassword;

    return Padding(
      padding: widget.padding ??
          const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: TextFormField(
        readOnly: widget.onPressed != null,
        onTap: widget.onPressed,
        onFieldSubmitted: widget.onSubmit,
        maxLength: widget.maxLength,
        minLines: widget.isTextArea ? 6 : null,
        keyboardType: widget.isNumber
            ? TextInputType.phone
            : widget.isTextArea
                ? TextInputType.multiline
                : null,
        maxLines: widget.isTextArea ? null : 1,
        enabled: widget.enabled,
        //readOnly: widget.readOnly,
        controller: widget.controller,
        cursorColor: widget.textColor,
        obscureText: isPassword && !isPwdVisible,
        style: Global.genericText.apply(
            color: widget.entryTextColor ?? widget.textColor,
            fontSizeFactor: widget.tweenValue ?? 1),
        decoration: InputDecoration(
          counterStyle: const TextStyle(
            color: Colors.black,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  onPressed: () {
                    isPwdVisible = !isPwdVisible;
                    setState(() {});
                  },
                  icon: isPwdVisible
                      ? Icon(FontAwesomeIcons.eyeSlash,
                          size: 18 * (widget.tweenValue ?? 1),
                          color: widget.textColor)
                      : Icon(
                          FontAwesomeIcons.eye,
                          color: widget.textColor,
                          size: 18 * (widget.tweenValue ?? 1),
                        ))
              : widget.suffixIcon != null
                  ? IconButton(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      onPressed: () => widget.onPressed ?? {},
                      icon: widget.suffixIcon!)
                  : null,
          labelText: widget.required ? widget.label + " *" : widget.label,
          labelStyle: Global.genericText.apply(
              color:
                  //Colors.white
                  !widget.isLocked ? widget.textColor : Global.disabledText),
          alignLabelWithHint: true,
          floatingLabelBehavior: widget.flb ??
              (widget.style == Global.tbox_style_ulined
                  ? FloatingLabelBehavior.always
                  : FloatingLabelBehavior.auto), //FloatingLabelBehavior.always,
          //isDense: true,
          contentPadding: widget.style == Global.tbox_style_ulined
              ? const EdgeInsets.only(left: 10, bottom: 10)
              : EdgeInsets.only(
                  top: widget.style == Global.tbox_style_tarea ? 30 : 20,
                  left: 20,
                  right: 20),
          enabledBorder: widget.tweenValue == 0
              ? InputBorder.none
              : widget.style == Global.tbox_style_pill ||
                      widget.style == Global.tbox_style_tarea
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.radius),
                      borderSide: BorderSide(
                          color: widget.borderColor ?? widget.textColor))
                  : UnderlineInputBorder(
                      borderSide: BorderSide(color: widget.textColor)),
          focusedBorder: widget.tweenValue == 0
              ? InputBorder.none
              : widget.style == Global.tbox_style_pill ||
                      widget.style == Global.tbox_style_tarea
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.radius),
                      borderSide: BorderSide(
                          color: widget.borderColor ?? widget.textColor))
                  : UnderlineInputBorder(
                      borderSide: BorderSide(color: widget.textColor)),
          border: widget.tweenValue == 0
              ? InputBorder.none
              : widget.style == Global.tbox_style_pill ||
                      widget.style == Global.tbox_style_tarea
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.radius),
                      borderSide: BorderSide(
                          color: widget.borderColor ?? widget.textColor))
                  : UnderlineInputBorder(
                      borderSide: BorderSide(color: widget.textColor)),
          filled: true,
          hintStyle: TextStyle(
              color: !widget.isLocked
                  ? widget.textColor.withOpacity(0.8)
                  : Colors.white,
              fontSize: 14 * (widget.tweenValue ?? 1)),
          hintText: widget.hint,
          fillColor: widget.isLocked
              ? Colors.grey.withOpacity(0.8)
              //widget.fieldColor.withOpacity(0.1)
              : widget.fieldColor ?? Colors.white,
        ),
      ),
    );
  }
}
