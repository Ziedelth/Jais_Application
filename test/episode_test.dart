import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jais/components/episodes/episode_list.dart';
import 'package:jais/components/episodes/episode_loader_widget.dart';
import 'package:jais/components/episodes/episode_widget.dart';
import 'package:jais/mappers/episode_mapper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final episodeMapper = EpisodeMapper();
  const string =
      "GxBDEVWkQACtD7gxDPzA+ic4DIqLq1+kg/vM1lzJedN0hP6b5CRUIT+dvoieDtdZdhbsWAB/5MTPSf5w5NUJYcUrnmbR6eq7OkoRP1xLz49omRPHsBsoGdjR4cjj4MbE+RZiu82YLEajsoEwp2xqX3g7HMZDSDeWN2Dm6i5wyAFr1hJKu5RudOJ/7ddmqLaIxYtcu3iE/DcUmv1S/9n7uycmGVGbflQSneli7SrWITVCOQkFKX1/xHYIkdZREM/MFwtm4vWnX94MJz3jy2ID3D+x5ss6GLJZ/OjZzeu3l4xgnMP19xW+t+2KAecwCgRzGStiVaq+4dty8RCYDTnY4wZcbc7JFH+s3XaDUXydC2s3iP/HE498IG612hADiDdxxCPw+MzexqCV0fKRkO15EC03mO8Djsmbp9zWNFS0AA6PyNBb7WFYj/rIVm7onYRklLGFs13M++D2WKjrqjaSow0fu4dVsrerrGrLy9EcWJc5GKt2nPeWGjSl6vpVGGRls2RrpdiKHikw7iYgjwDyrAq1NgtaRWCo6mc4ZpkcZVXfkg/u3By24RcgrASfUNQPPkn9Kvc9+R/0gkay7ZhpRlYlL++QLW7Cw0wFLPwzLfObLSLbRIcUKoMJ1XptDsn5BEzq7bPoi1+9cHezAnLUqLJf/8/+9d+79T+T44pJWeMVLO38RMTYU6f8nIhMQAxC/Oet8G3bt+pkqL2h+/MvxkBuilkW8U+j6DVCNYRTw+NRUoOUliDjrNBAg6NtDzs1KizacjCsr+ypOLHPEd26294sA5qREnocPvhYwh1lFJGvBCbsWyKDG3IAQZNN4dt3TAdhQ/4iRJu5quQOKEmfk8KeadmWOmHMZ+iWdfvtJmbsF9FoYwt+8V24GeEmWN8l4nnmnGy4ZJoETiSY5JoIdcUJcUJX3kzMtDr27jpRPEiTARNQUJg9NkFfTF3Gr24xbOH3+fQpsjikiaeDDoYM2M9YVPTs/YFAV0RK4cDuzkQGO7ih9H9nqe0SQQK/KwSlBkM0wBohRJZmvD/Js9sdpUG/SYE+1SKvFOToOYMK1ggSOejTFE6p//iZB1BAAsueTrPftpGXVRqBHww5WaxG4LtI6cnddoCNA5RPQq9pYLozFes9gyF4AA6Gm5exWMByZPTRQgGdCY/c9PVgZmdbydLV3P8bMkQ3i4T4s8Rt+B6MMNN6KftFprjbUxEgo4FedMjxBNupaDHuaxjdSRl5AAEGG6FxuMFL+TQtVsPrXcS22LUZXMUM+tBDPeXQMqtyj/Q3gAegYLipGosE9ESyOZ3m9ZugFxL8aKfnddNs3V03NIqPdaWqS1rcUwdOgwXYg3aTbnEUXUiJB2BgsHEZi1Ayyb9iNTxtI2ZGbcGzsqQiSUJLQ5waqZBa9hjgATAYbg7GQgHxjkfwn3GEOlnEEf4qfajoH9M1GVe0nLgnGd2wUZkoF+q8CnKFD45rjNE0v0ISLEShNGoWq+HRiTJfb1UNHtpT0LYjQqpnoas76HgACHabnvdVuQAHyCYsFLNbHFdlCwnaXqQMY6tMEKvzNWm+Xmo+/fRzJV6Da9GgHbtuvzKeU1jUFachAg+AwF4T874qR64IOhar4d5x0d9UJ8xAleXkQqkQXMWDs8bakcG/yDH89pW5AM0Bv0Efd9O1SBjQouNtJUEHEkZAT+mrGKOaGGK993eJ+YySMAg8Drp3gGxJsGYIFHvTqDMIHL8iR/LbT+YNbgqkZbEabmd7qdEcK3aSF2VBBMpxIPD1FXYCGWEb";

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
      widgetTester.binding.window.physicalSizeTestValue = const Size(500, 700);

      final width = widgetTester.binding.window.physicalSize.width;
      final height = widgetTester.binding.window.physicalSize.height;
      print('width: $width, height: $height');

      final widgets = episodeMapper.toWidgets(string);
      final list = widgets;

      await widgetTester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EpisodeList(children: list),
          ),
        ),
      );

      await widgetTester.binding.setSurfaceSize(null);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(EpisodeWidget), findsWidgets);
    });

    testWidgets('Test episode widget on tablet', (widgetTester) async {
      widgetTester.binding.window.physicalSizeTestValue = const Size(1000, 700);

      final width = widgetTester.binding.window.physicalSize.width;
      final height = widgetTester.binding.window.physicalSize.height;
      print('width: $width, height: $height');

      final widgets = episodeMapper.toWidgets(string);
      final list = widgets;

      await widgetTester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EpisodeList(children: list),
          ),
        ),
      );

      await widgetTester.binding.setSurfaceSize(null);
      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(EpisodeWidget), findsWidgets);
    });
  });
}
