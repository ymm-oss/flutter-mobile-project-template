import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/providers/maintenance_policy_notifier_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internal_design_ui/i18n.dart';

class MaintenancePage extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context).maintenance;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.appBarTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              t.description,
            ),
            const SizedBox(height: 64),
            ElevatedButton(
              onPressed: () {
                ref.read(maintenancePolicyProvider.notifier).disable();
              },
              child: Text(t.disableButtonLabel),
            ),
          ],
        ),
      ),
    );
  }
}
