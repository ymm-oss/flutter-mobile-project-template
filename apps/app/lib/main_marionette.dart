// Marionette はデバッグ専用の dev_dependency として、この entrypoint からのみ利用する。
// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:flutter_app/main.dart' as app;
import 'package:marionette_flutter/marionette_flutter.dart';

Future<void> main() async {
  final logCollector = PrintLogCollector();
  await runZoned(
    () async {
      MarionetteBinding.ensureInitialized(
        MarionetteConfiguration(
          enableSessionReports: true,
          logCollector: logCollector,
        ),
      );
      await app.runApplication();
    },
    zoneSpecification: ZoneSpecification(
      print: (self, parent, zone, line) {
        parent.print(zone, line);
        logCollector.addLog(line);
      },
    ),
  );
}
