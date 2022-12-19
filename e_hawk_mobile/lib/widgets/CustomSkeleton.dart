import 'package:e_hawk_mobile/utilities/Global.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class CustomSkeleton extends StatelessWidget {
  final Widget child;
  final bool loadState;
  final bool isCircle;
  final bool isRounded;
  final String? tooltip;

  const CustomSkeleton(
      {Key? key,
      required this.child,
      required this.loadState,
      this.isCircle = false,
      this.isRounded = false,
      this.tooltip})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!loadState) {
      if (tooltip == null) return child;
      return Tooltip(
          showDuration: const Duration(seconds: 3),
          padding: const EdgeInsets.all(5),
          message: tooltip,
          child: child);
    }
    return Container(
        decoration: BoxDecoration(
            color: Global.accent.withOpacity(0.3),
            borderRadius: isCircle
                ? BorderRadius.circular(50)
                : isRounded
                    ? BorderRadius.circular(15)
                    : BorderRadius.circular(5)),
        //shape: isCircle ? BoxShape.circle : isRounded ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)) : BoxShape.rectangle),
        child: SkeletonAnimation(
          shimmerColor: Global.accent.withOpacity(0.7),
          borderRadius: isCircle
              ? BorderRadius.circular(50) //<= full circle
              : isRounded
                  ? BorderRadius.circular(15) //<= standardized val = 15
                  : BorderRadius.circular(5),
          //gradientColor: Jejalin.color_primary.withOpacity(0.3),
          child:
              Opacity(alwaysIncludeSemantics: true, opacity: 0, child: child),
        ));
  }
}
