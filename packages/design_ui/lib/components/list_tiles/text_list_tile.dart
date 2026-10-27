import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// example component
class TextListTile extends StatelessWidget {
  const new({
    required this.text,
    required this.onTap,
    super.key,
  });

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(text),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('text', text, defaultValue: ''));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap));
  }
}
