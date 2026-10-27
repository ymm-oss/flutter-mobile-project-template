import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shake_gesture/shake_gesture.dart';

class ShakeDetection extends StatelessWidget {
  const new({
    required this.onShake,
    required this.child,
    super.key,
  });

  final VoidCallback onShake;
  final Widget child;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback>.has('onShake', onShake));
    properties.add(ObjectFlagProperty<Widget>.has('child', child));
  }

  @override
  Widget build(BuildContext context) {
    return ShakeGesture(
      onShake: onShake,
      child: child,
    );
  }
}
