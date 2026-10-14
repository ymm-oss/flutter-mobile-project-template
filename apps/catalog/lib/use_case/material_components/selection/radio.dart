import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

/// Radio
/// https://api.flutter.dev/flutter/material/Radio-class.html

@UseCase(
  name: 'Radio',
  type: Radio,
  path: '[Theme Preview]/Selection',
)
Widget radio(BuildContext context) {
  _SingingCharacter? character = _SingingCharacter.lafayette;

  return StatefulBuilder(
    builder: (context, setState) {
      return Center(
        child: RadioGroup<_SingingCharacter>(
          groupValue: character,
          onChanged: (value) {
            setState(() {
              character = value;
            });
          },
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('Lafayette'),
                leading: Radio<_SingingCharacter>(
                  value: _SingingCharacter.lafayette,
                ),
              ),
              ListTile(
                title: Text('Thomas Jefferson'),
                leading: Radio<_SingingCharacter>(
                  value: _SingingCharacter.jefferson,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

enum _SingingCharacter { lafayette, jefferson }
