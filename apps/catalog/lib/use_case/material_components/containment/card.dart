import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

/// Card
/// https://api.flutter.dev/flutter/material/Card-class.html

class _SampleCard extends StatelessWidget {
  const _SampleCard({
    required this._name,
  });

  final String _name;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: SizedBox(
        width: 300,
        height: 100,
        child: Center(child: Text(_name)),
      ),
    );
  }
}

@UseCase(
  name: 'Elevated',
  type: Card,
  path: '[Theme Preview]/Containment',
)
Widget elevatedCard(BuildContext context) => const Center(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Card(
      clipBehavior: Clip.hardEdge,
      child: _SampleCard(name: 'Elevated Card'),
    ),
  ),
);

@UseCase(
  name: 'Outlined',
  type: Card,
  path: '[Theme Preview]/Containment',
)
Widget outlinedCard(BuildContext context) => const Center(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Card.outlined(
      clipBehavior: Clip.hardEdge,
      child: _SampleCard(name: 'Outlined Card'),
    ),
  ),
);

@UseCase(
  name: 'Filled',
  type: Card,
  path: '[Theme Preview]/Containment',
)
Widget filledCard(BuildContext context) => const Center(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Card.filled(
      clipBehavior: Clip.hardEdge,
      child: _SampleCard(name: 'Filled Card'),
    ),
  ),
);
