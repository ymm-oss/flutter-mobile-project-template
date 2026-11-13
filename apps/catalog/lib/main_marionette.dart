// Marionette はデバッグ専用の dev_dependency として、この entrypoint からのみ利用する。
// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:catalog/main.dart' as catalog;
import 'package:marionette_flutter/marionette_flutter.dart';

void main() {
  final logCollector = PrintLogCollector();
  runZoned(
    () {
      MarionetteBinding.ensureInitialized(
        MarionetteConfiguration(
          enableSessionReports: true,
          logCollector: logCollector,
        ),
      );
      catalog.runApplication();
    },
    zoneSpecification: ZoneSpecification(
      print: (self, parent, zone, line) {
        parent.print(zone, line);
        logCollector.addLog(line);
      },
    ),
  );
}
