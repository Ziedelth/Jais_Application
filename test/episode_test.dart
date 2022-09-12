import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jais/components/episodes/episode_list.dart';
import 'package:jais/components/episodes/episode_loader_widget.dart';
import 'package:jais/components/episodes/episode_widget.dart';
import 'package:jais/mappers/episode_mapper.dart';

import 'const_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final episodeMapper = EpisodeMapper();
  const string =
      "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";

  group('Test episodes', () {
    test('Test transformation', () {
      final list = episodeMapper.toWidgets(string);

      expect(list.length, episodeMapper.limit);
      expect(list.whereType<EpisodeWidget>().length, episodeMapper.limit);
    });

    test('Test loading episodes', () {
      expect(episodeMapper.list.length, 0);
      episodeMapper.addLoader();
      expect(episodeMapper.list.length, episodeMapper.limit);

      expect(
        episodeMapper.list.whereType<EpisodeLoaderWidget>().length,
        episodeMapper.limit,
      );

      episodeMapper.removeLoader();
      expect(episodeMapper.list.length, 0);
    });

    testWidgets('Test episode widget on phone', (widgetTester) async {
      for (final size in phoneSizes) {
        await testOrientation(
          widgetTester,
          episodeMapper,
          string,
          size.width,
          size.height,
          ListView,
          GridView,
        );
      }
    });

    testWidgets('Test episode widget on tablet', (widgetTester) async {
      for (final size in tabletSizes) {
        await testOrientation(
          widgetTester,
          episodeMapper,
          string,
          size.width,
          size.height,
          GridView,
          GridView,
        );
      }
    });
  });
}

Future<void> testOrientation(
  WidgetTester widgetTester,
  EpisodeMapper episodeMapper,
  String string,
  double width,
  double height,
  Type type1,
  Type type2,
) async {
  await testWidget(
    widgetTester,
    episodeMapper,
    string,
    Size(width, height),
    type1,
  );
  await testWidget(
    widgetTester,
    episodeMapper,
    string,
    Size(height, width),
    type2,
  );
}

Future<void> testWidget(
  WidgetTester widgetTester,
  EpisodeMapper episodeMapper,
  String string,
  Size size,
  Type type,
) async {
  widgetTester.binding.window.devicePixelRatioTestValue = 1.0;
  widgetTester.binding.window.physicalSizeTestValue = size;

  final widgets = episodeMapper.toWidgets(string);
  final list = widgets;

  await widgetTester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: EpisodeList(children: list),
      ),
    ),
  );

  expect(find.byType(type), findsOneWidget);
  expect(find.byType(EpisodeWidget), findsWidgets);
}
