import 'package:e_hawk_mobile/utilities/Global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  CustomButton(
      {Key? key,
      required this.label,
      required this.onpress,
      this.width,
      this.height,
      this.prefixIcon,
      this.suffixIcon,
      this.color,
      this.textColor,
      this.borderColor,
      this.style = Global.btn_medium,
      this.margin,
      this.labelStyle,
      this.padding,
      this.enabled = true,
      this.radius})
      : super(key: key);

  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final String label;
  final TextStyle? labelStyle;
  final String style;
  final VoidCallback onpress;
  final Color? color;
  final Color? textColor;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final bool enabled;
  final double? width;
  final double? height;
  final double? radius;
  final Color? borderColor;

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  BuildContext? _ctx;
  bool isList = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    Widget? render;
    switch (widget.style) {
      case Global.btn_ctaSmall:
        render = cta_small();
        break;
      case Global.btn_controlSmall:
        render = control_small();
        break;
      default:
    }
    return render ??
        Container(
          margin: widget.margin ??
              (widget.style == Global.btn_small
                  ? const EdgeInsets.symmetric(vertical: 10)
                  : const EdgeInsets.symmetric(vertical: 20)),
          height: widget.height,
          width: widget.width ?? (widget.style == Global.btn_small ? 100 : 200),
          child: TextButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(widget.radius ?? 10.0),
                        side: BorderSide(
                            color: widget.enabled
                                ? widget.color ?? Colors.black
                                : Colors.grey))),
                backgroundColor: MaterialStateProperty.all<Color>(widget.enabled
                    ? widget.color ?? Colors.black
                    : Colors.grey)),
            child: widget.prefixIcon != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                        widget.prefixIcon!,
                        Center(
                          child: Text(
                            widget.label.toUpperCase(),
                            overflow: TextOverflow.fade,
                            style: widget.labelStyle ??
                                Global.genericText.apply(
                                    color: widget.textColor ?? Colors.white),
                          ),
                        ),
                      ])
                : Center(
                    child: Text(
                      widget.label.toUpperCase(),
                      style: widget.labelStyle ??
                          Global.genericText
                              .apply(color: widget.textColor ?? Colors.white),
                    ),
                  ),
            onPressed: widget.onpress,
          ),
        );
  }

  Widget cta_small() {
    return TextButton(
      style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(5)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.radius ?? 20.0),
                  side: BorderSide(
                      color: widget.enabled
                          ? widget.textColor ?? Colors.black
                          : Colors.grey))),
          backgroundColor:
              MaterialStateProperty.all<Color>(Colors.transparent)),
      child: Center(
        child: Text(
          widget.label.toUpperCase(),
          style: widget.labelStyle ??
              Global.genericText.apply(color: widget.textColor),
        ),
      ),
      onPressed: widget.onpress,
    );
  }

  Widget control_small() {
    return TextButton(
      style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.radius ?? 10.0),
                  side: BorderSide(
                      color: widget.enabled
                          ? widget.textColor ?? Colors.black
                          : Colors.grey))),
          backgroundColor:
              MaterialStateProperty.all<Color>(Colors.transparent)),
      child: Center(
          child: widget.suffixIcon != null || widget.prefixIcon != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                      widget.prefixIcon ?? SizedBox.shrink(),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          widget.label.toUpperCase(),
                          overflow: TextOverflow.fade,
                          style: widget.labelStyle ??
                              Global.genericText.apply(
                                  color: widget.textColor ?? Colors.black),
                        ),
                      ),
                      widget.suffixIcon ?? SizedBox.shrink(),
                    ])
              : Center(
                  child: Text(
                    widget.label.toUpperCase(),
                    style: widget.labelStyle ??
                        Global.genericText
                            .apply(color: widget.textColor ?? Colors.black),
                  ),
                )),
      onPressed: widget.onpress,
    );
  }
}
