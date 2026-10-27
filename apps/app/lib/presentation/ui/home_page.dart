import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internal_design_theme/theme_extensions.dart';
import 'package:internal_design_ui/i18n.dart';

class HomePage extends ConsumerWidget {
  const new({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context).home;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.appBarTitle),
        iconTheme: IconTheme.of(context).copyWith(
          color: context.appColors.icon,
        ),
      ),
      body: Center(
        child: Text(t.title),
      ),
    );
  }
}
