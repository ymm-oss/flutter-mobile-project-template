import 'package:catalog/main.directories.g.dart';
import 'package:flutter/material.dart';
import 'package:internal_design_theme/themes.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

void main() {
  // catalog は Riverpod を使わないため ProviderScope は不要
  // ignore: riverpod_lint/missing_provider_scope
  runApp(const WidgetbookApp());
}

@App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: directories,
      // 下のAddonから順番にUseCaseを囲んでいく仕様になっている
      // 例えば、InspectorはDeviceFrameの中に表示される
      addons: [
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(name: 'Light', data: lightTheme()),
            WidgetbookTheme(name: 'Dark', data: darkTheme()),
          ],
        ),
        ViewportAddon(
          [
            IosViewports.iPhoneSE,
            IosViewports.iPhone13,
            IosViewports.iPad,
            AndroidViewports.samsungGalaxyA50,
            AndroidViewports.largeTablet,
          ],
        ),
        InspectorAddon(enabled: true),
        LocalizationAddon(
          locales: [
            const Locale('en', 'US'),
            const Locale('ja', 'JP'),
          ],
          localizationsDelegates: [
            DefaultWidgetsLocalizations.delegate,
            DefaultMaterialLocalizations.delegate,
          ],
        ),
        BuilderAddon(
          name: 'Scaffold',
          builder: (context, child) {
            // 再帰的にScaffoldの有無を確認する関数
            bool searchScaffold(Element element, int depth) {
              // 現在のWidgetbookは最上位近くにScaffoldがあるため、それを除外するためにdepthを比較している
              final hasScaffold = depth > 1 && element.widget is Scaffold;
              if (hasScaffold) {
                return true;
              }

              var hasScaffoldInChildren = false;
              // 子要素を走査
              element.visitChildren((child) {
                if (!hasScaffoldInChildren) {
                  hasScaffoldInChildren = searchScaffold(child, depth + 1);
                }
              });

              return hasScaffoldInChildren;
            }

            // 走査開始
            final element = context as Element;
            final hasScaffold = searchScaffold(element, 0);

            return hasScaffold
                ? child
                : Scaffold(
                    body: child,
                  );
          },
        ),
        BuilderAddon(
          name: 'SafeArea',
          builder: (context, child) => SafeArea(child: child),
        ),
        AlignmentAddon(),
        TextScaleAddon(),
      ],
    );
  }
}
