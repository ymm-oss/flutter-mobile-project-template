import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(
  name: 'Default',
  type: ColorScheme,
  designLink: 'https://m3.material.io/styles/color/overview',
  path: '[Theme Preview]/Style',
)
Widget buildThemeColorSchemeUseCase(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  return Scaffold(
    body: SafeArea(
      child: ListView(
        children: [
          // Primary
          _ColorPreviewTile(
            title: const Text('Primary'),
            color: colorScheme.primary,
          ),
          _ColorPreviewTile(
            title: const Text('On Primary'),
            color: colorScheme.onPrimary,
          ),
          _ColorPreviewTile(
            title: const Text('Primary Container'),
            color: colorScheme.primaryContainer,
          ),
          _ColorPreviewTile(
            title: const Text('On Primary Container'),
            color: colorScheme.onPrimaryContainer,
          ),
          // Secondary
          _ColorPreviewTile(
            title: const Text('Secondary'),
            color: colorScheme.secondary,
          ),
          _ColorPreviewTile(
            title: const Text('On Secondary'),
            color: colorScheme.onSecondary,
          ),
          _ColorPreviewTile(
            title: const Text('Secondary Container'),
            color: colorScheme.secondaryContainer,
          ),
          _ColorPreviewTile(
            title: const Text('On Secondary Container'),
            color: colorScheme.onSecondaryContainer,
          ),
          // Tertiary
          _ColorPreviewTile(
            title: const Text('Tertiary'),
            color: colorScheme.tertiary,
          ),
          _ColorPreviewTile(
            title: const Text('On Tertiary'),
            color: colorScheme.onTertiary,
          ),
          _ColorPreviewTile(
            title: const Text('Tertiary Container'),
            color: colorScheme.tertiaryContainer,
          ),
          _ColorPreviewTile(
            title: const Text('On Tertiary Container'),
            color: colorScheme.onTertiaryContainer,
          ),
          // Error
          _ColorPreviewTile(
            title: const Text('Error'),
            color: colorScheme.error,
          ),
          _ColorPreviewTile(
            title: const Text('On Error'),
            color: colorScheme.onError,
          ),
          _ColorPreviewTile(
            title: const Text('Error Container'),
            color: colorScheme.errorContainer,
          ),
          _ColorPreviewTile(
            title: const Text('On Error Container'),
            color: colorScheme.onErrorContainer,
          ),
          // Surface
          _ColorPreviewTile(
            title: const Text('Surface'),
            color: colorScheme.surface,
          ),
          _ColorPreviewTile(
            title: const Text('On Surface'),
            color: colorScheme.onSurface,
          ),
          _ColorPreviewTile(
            title: const Text('Surface Variant'),
            color: colorScheme.surfaceContainerHighest,
          ),
          _ColorPreviewTile(
            title: const Text('On Surface Variant'),
            color: colorScheme.onSurfaceVariant,
          ),
          _ColorPreviewTile(
            title: const Text('Surface Tint'),
            color: colorScheme.surfaceTint,
          ),
          _ColorPreviewTile(
            title: const Text('Inverse Surface'),
            color: colorScheme.inverseSurface,
          ),
          _ColorPreviewTile(
            title: const Text('On Inverse Surface'),
            color: colorScheme.onInverseSurface,
          ),
          // Background
          _ColorPreviewTile(
            title: const Text('Background'),
            color: colorScheme.surface,
          ),
          _ColorPreviewTile(
            title: const Text('On Background'),
            color: colorScheme.onSurface,
          ),
          // Outline
          _ColorPreviewTile(
            title: const Text('Outline'),
            color: colorScheme.outline,
          ),
          _ColorPreviewTile(
            title: const Text('Outline Variant'),
            color: colorScheme.outlineVariant,
          ),
          // Scrim & Shadow
          _ColorPreviewTile(
            title: const Text('Scrim'),
            color: colorScheme.scrim,
          ),
          _ColorPreviewTile(
            title: const Text('Shadow'),
            color: colorScheme.shadow,
          ),
        ],
      ),
    ),
  );
}

class _ColorPreviewTile extends StatelessWidget {
  const new({
    required this._title,
    required this._color,
  });

  final Widget _title;
  final Color _color;

  String get _colorDescription {
    String toHex(double value) {
      return (value * 255)
          .round()
          .toRadixString(16)
          .padLeft(2, '0')
          .toUpperCase();
    }

    final hex =
        '${toHex(_color.r)}'
        '${toHex(_color.g)}'
        '${toHex(_color.b)}'
        '${toHex(_color.a)}';
    final rgb = '${_color.r * 255}, ${_color.g * 255}, ${_color.b * 255}';

    return 'HEX: #$hex, RGB: ($rgb)';
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: _title,
      subtitle: SelectableText(_colorDescription),
      trailing: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: _color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ),
    );
  }
}
