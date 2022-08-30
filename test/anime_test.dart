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
