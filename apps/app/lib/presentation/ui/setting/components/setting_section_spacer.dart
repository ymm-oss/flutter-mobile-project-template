import 'package:flutter/material.dart';

/// [SettingSectionSpacer] is a widget that represents the spacer between
/// sections in the settings screen.
final class SettingSectionSpacer extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) => const SliverToBoxAdapter(
    child: SizedBox(height: 24),
  );
}
