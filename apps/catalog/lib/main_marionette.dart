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
