import 'package:flutter/material.dart';
import 'package:rsnaturopaty/widget/widget_all/WCustomeCurveEdges.dart';

class CurvedEdgesWidget extends StatelessWidget {
  const CurvedEdgesWidget({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CustomeCurveEdges(),
      child: child,
    );
  }
}
