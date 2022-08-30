import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jais/components/simulcasts/simulcast_list.dart';
import 'package:jais/components/simulcasts/simulcast_loader_widget.dart';
import 'package:jais/components/simulcasts/simulcast_widget.dart';
import 'package:jais/mappers/simulcast_mapper.dart';

import 'const_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final simulcastMapper = SimulcastMapper();
  const string = "G40AIJwHto1u7QNPckk1rSRlhEqHiRxqyzS9yy1vqdqF5glFsCnV7MNvHvNP6uz1JUvXMDjhAFOfapZ4kuKZH4ZWNC4nPwUZRDDRN0c3B5TnWxcHoYhlQGvy+Yog+Vc6WI8JudU/CQ==";

  group('Test simulcasts', () {
    test('Test transformation', () {
      final list = simulcastMapper.toWidgets(string);

      expect(list.length, 4);
      expect(list.whereType<SimulcastWidget>().length, 4);
    });

    test('Test loading simulcasts', () {
      expect(simulcastMapper.list.length, 0);
      simulcastMapper.addLoader();
      expect(simulcastMapper.list.length, simulcastMapper.limit);

      expect(
        simulcastMapper.list.whereType<SimulcastLoaderWidget>().length,
        simulcastMapper.limit,
      );

      simulcastMapper.removeLoader();
      expect(simulcastMapper.list.length, 0);
    });

    testWidgets('Test simulcast widget on phone', (widgetTester) async {
      for (final size in phoneSizes) {
        await testOrientation(
          widgetTester,
          simulcastMapper,
          string,
          size.width,
          size.height,
          ListView,
        );
      }
    });

    testWidgets('Test simulcast widget on tablet', (widgetTester) async {
      for (final size in tabletSizes) {
        await testOrientation(
          widgetTester,
          simulcastMapper,
          string,
          size.width,
          size.height,
          ListView,
        );
      }
    });
  });
}

Future<void> testOrientation(
  WidgetTester widgetTester,
  SimulcastMapper simulcastMapper,
  String string,
  double width,
  double height,
  Type type,
) async {
  await testWidget(
    widgetTester,
    simulcastMapper,
    string,
    Size(width, height),
    type,
  );
  await testWidget(
    widgetTester,
    simulcastMapper,
    string,
    Size(height, width),
    type,
  );
}

Future<void> testWidget(
  WidgetTester widgetTester,
  SimulcastMapper simulcastMapper,
  String string,
  Size size,
  Type type,
) async {
  widgetTester.binding.window.devicePixelRatioTestValue = 1.0;
  widgetTester.binding.window.physicalSizeTestValue = size;

  final widgets = simulcastMapper.toWidgets(string);
  final list = widgets;

  await widgetTester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SimulcastList(children: list),
      ),
    ),
  );

  expect(find.byType(type), findsOneWidget);
  expect(find.byType(SimulcastWidget), findsWidgets);
}
