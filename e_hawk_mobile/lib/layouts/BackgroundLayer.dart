import 'package:e_hawk_mobile/utilities/Global.dart';
import 'package:flutter/material.dart';

class BackgroundLayer extends StatefulWidget {
  BackgroundLayer(
      {Key? key,
      required this.child,
      this.useCrescent = false,
      this.height,
      this.useJ = false,
      this.useImageBg = false,
      this.useTopCurve = false,
      this.useGradient = false,
      this.customColor,
      this.customGradient})
      : super(key: key);

  final double? height;
  final Widget child;
  final bool useJ;
  final Color? customColor;
  final bool useTopCurve;
  final bool useCrescent;
  final bool useImageBg;
  final bool useGradient;
  final LinearGradient? customGradient;

  @override
  _BackgroundLayerState createState() => _BackgroundLayerState();
}

class _BackgroundLayerState extends State<BackgroundLayer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: widget.useTopCurve
              ? const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))
              : null,
          image: widget.useImageBg
              ? const DecorationImage(
                  image: AssetImage('assets/icons/header.png'),
                  fit: BoxFit.cover)
              : null,
          gradient: widget.useGradient
              ? widget.customGradient ??
                  const LinearGradient(
                      //default gradient
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0, 0.15],
                      colors: [Global.primary, Global.accent])
              : null,
          color: widget.customColor ?? Global.cardDefault,
        ),
        child: widget.useTopCurve
            ? ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                clipBehavior: Clip.antiAlias,
                child: innerChild())
            : innerChild());
  }

  Widget innerChild() {
    return widget.useJ
        ? Stack(children: <Widget>[
            Positioned.fill(
              child: Image.asset(Global.bgImage,
                  color: const Color.fromRGBO(255, 255, 255, 0.25),
                  colorBlendMode: BlendMode.modulate,
                  fit: BoxFit.contain),
            ),
            widget.useCrescent
                ? Positioned.fill(
                    bottom: MediaQuery.of(context).size.height * 0.55,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.elliptical(
                                MediaQuery.of(context).size.width, 180.0)),
                      ),
                    ))
                : Container(),
            widget.child,
          ])
        : widget.child;
  }
}
