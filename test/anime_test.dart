import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jais/components/animes/anime_list.dart';
import 'package:jais/components/animes/anime_loader_widget.dart';
import 'package:jais/components/animes/anime_widget.dart';
import 'package:jais/mappers/anime_mapper.dart';

import 'const_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final animeMapper = AnimeMapper();
  const string =
      "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";

  group('Test animes', () {
    test('Test transformation', () {
      final list = animeMapper.toWidgets(string);

      expect(list.length, animeMapper.limit);
      expect(list.whereType<AnimeWidget>().length, animeMapper.limit);
    });

    test('Test loading animes', () {
      expect(animeMapper.list.length, 0);
      animeMapper.addLoader();
      expect(animeMapper.list.length, animeMapper.limit);

      expect(
        animeMapper.list.whereType<AnimeLoaderWidget>().length,
        animeMapper.limit,
      );

      animeMapper.removeLoader();
      expect(animeMapper.list.length, 0);
    });

    testWidgets('Test anime widget on phone', (widgetTester) async {
      for (final size in phoneSizes) {
        await testOrientation(
          widgetTester,
          animeMapper,
          string,
          size.width,
          size.height,
        );
      }
    });

    testWidgets('Test anime widget on tablet', (widgetTester) async {
      for (final size in tabletSizes) {
        await testOrientation(
          widgetTester,
          animeMapper,
          string,
          size.width,
          size.height,
        );
      }
    });
  });
}

Future<void> testOrientation(
  WidgetTester widgetTester,
  AnimeMapper animeMapper,
  String string,
  double width,
  double height,
) async {
  await testWidget(
    widgetTester,
    animeMapper,
    string,
    Size(width, height),
  );
  await testWidget(
    widgetTester,
    animeMapper,
    string,
    Size(height, width),
  );
}

Future<void> testWidget(
  WidgetTester widgetTester,
  AnimeMapper animeMapper,
  String string,
  Size size,
) async {
  widgetTester.binding.window.devicePixelRatioTestValue = 1.0;
  widgetTester.binding.window.physicalSizeTestValue = size;

  final widgets = animeMapper.toWidgets(string);
  final list = widgets;

  await widgetTester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: AnimeList(children: list),
        ),
      ),
    ),
  );

  expect(find.byType(AnimeWidget), findsWidgets);
}
