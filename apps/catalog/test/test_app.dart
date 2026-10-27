import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internal_design_theme/themes.dart';

import 'test_devices.dart';

void goldenTestsGroup({
  required String componentName,
  required List<TestScenario> testScenarios,
  TestDevices device = const IPhone16ProMax(),
  PumpWidget? pumpWidget,
  PumpAction? pumpBeforeTest,
}) {
  group(
    '$componentName Tests',
    () {
      for (final theme in [lightTheme(), darkTheme()]) {
        //
        // ignore: discarded_futures
        goldenTest(
          'Render correctly ${device.runtimeType} ${theme.brightness.name}',
          fileName:
              '${componentName}_${device.runtimeType}_${theme.brightness.name}',
          pumpBeforeTest: pumpBeforeTest ?? onlyPumpAndSettle,
          pumpWidget: pumpWidget ?? onlyPumpWidget,
          builder: () => GoldenTestGroup(
            scenarioConstraints: device.constraints,
            children: testScenarios
                .map(
                  (scenario) => GoldenTestScenario(
                    name: scenario.name,
                    child: MaterialApp(
                      debugShowCheckedModeBanner: false,
                      theme: theme,
                      home: Scaffold(
                        body: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: scenario.child,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        );
      }
    },
  );
}

class TestScenario {
  const new({
    required this.child,
    this.name = 'Default',
  });

  final String name;
  final Widget child;
}
