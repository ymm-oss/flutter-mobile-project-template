import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(
  name: 'Default',
  type: TextTheme,
  designLink: 'https://m3.material.io/styles/typography/overview',
  path: '[Theme Preview]/Style',
)
Widget buildThemeTypographyUseCase(BuildContext context) {
  final theme = Theme.of(context);
  return Scaffold(
    body: SafeArea(
      child: ListView(
        children: [
          // Display
          _TextStylePreviewTile(
            title: const Text('Display Large'),
            textStyle: theme.textTheme.displayLarge,
          ),
          _TextStylePreviewTile(
            title: const Text('Display Medium'),
            textStyle: theme.textTheme.displayMedium,
          ),
          _TextStylePreviewTile(
            title: const Text('Display Small'),
            textStyle: theme.textTheme.displaySmall,
          ),
          // Headline
          _TextStylePreviewTile(
            title: const Text('Headline Large'),
            textStyle: theme.textTheme.headlineLarge,
          ),
          _TextStylePreviewTile(
            title: const Text('Headline Medium'),
            textStyle: theme.textTheme.headlineMedium,
          ),
          _TextStylePreviewTile(
            title: const Text('Headline Small'),
            textStyle: theme.textTheme.headlineSmall,
          ),
          // Title
          _TextStylePreviewTile(
            title: const Text('Title Large'),
            textStyle: theme.textTheme.titleLarge,
          ),
          _TextStylePreviewTile(
            title: const Text('Title Medium'),
            textStyle: theme.textTheme.titleMedium,
          ),
          _TextStylePreviewTile(
            title: const Text('Title Small'),
            textStyle: theme.textTheme.titleSmall,
          ),
          // Body
          _TextStylePreviewTile(
            title: const Text('Body Large'),
            textStyle: theme.textTheme.bodyLarge,
          ),
          _TextStylePreviewTile(
            title: const Text('Body Medium'),
            textStyle: theme.textTheme.bodyMedium,
          ),
          _TextStylePreviewTile(
            title: const Text('Body Small'),
            textStyle: theme.textTheme.bodySmall,
          ),
          // Label
          _TextStylePreviewTile(
            title: const Text('Label Large'),
            textStyle: theme.textTheme.labelLarge,
          ),
          _TextStylePreviewTile(
            title: const Text('Label Medium'),
            textStyle: theme.textTheme.labelMedium,
          ),
          _TextStylePreviewTile(
            title: const Text('Label Small'),
            textStyle: theme.textTheme.labelSmall,
          ),
        ],
      ),
    ),
  );
}

class _TextStylePreviewTile extends StatelessWidget {
  const _TextStylePreviewTile({
    required this._title,
    required this._textStyle,
  });
  final Widget _title;
  final TextStyle? _textStyle;

  String get _textStyleDescription {
    final textStyle = _textStyle;
    if (textStyle == null) {
      return 'undefined';
    }
    //
    // ignore: lines_longer_than_80_chars
    return 'Font Size: ${textStyle.fontSize}, Weight: ${textStyle.fontWeight?.value}, Letter Spacing: ${textStyle.letterSpacing}';
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: _title,
      titleTextStyle: _textStyle,
      subtitle: SelectableText(_textStyleDescription),
    );
  }
}
