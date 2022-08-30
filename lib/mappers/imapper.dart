import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jais/utils/utils.dart';
import 'package:logger/logger.dart';
import 'package:url/url.dart';

abstract class IMapper<T> extends ChangeNotifier {
  final int limit;
  final Widget loaderWidget;
  final list = <Widget>[];
  final scrollController = ScrollController();
  final T Function(Map<String, dynamic>) fromJson;
  final Widget Function(T) toWidget;
  int currentPage = 1;
  bool isLoading = false;
  bool canLoadMore = true;

  IMapper({
    required this.limit,
    required this.loaderWidget,
    required this.fromJson,
    required this.toWidget,
    bool listener = true,
  }) {
    if (listener) {
      scrollController.addListener(() async {
        if (scrollController.position.extentAfter <= 0 &&
            !isLoading &&
            canLoadMore) {
          isLoading = true;
          Logger.info('Clearing images cache...');
          clearImagesCache();
          currentPage++;
          Logger.debug('Loading page $currentPage...');
          await updateCurrentPage();
          isLoading = false;
          canLoadMore = list.length % limit == 0;
          Logger.debug('Can load more: $canLoadMore');
        }
      });
    }
  }

  List<Widget> get defaultList => List.filled(
        limit,
        loaderWidget,
        growable: true,
      );

  void addLoader() {
    list.addAll(defaultList);
    notifyListeners();
  }

  void clear() {
    currentPage = 1;
    list.clear();
    isLoading = false;
    canLoadMore = true;
    addLoader();
  }

  void removeLoader() {
    list.removeWhere(
      (element) => element.runtimeType == loaderWidget.runtimeType,
    );

    notifyListeners();
  }

  List<Widget> toWidgets(String string) {
    try {
      return (jsonDecode(fromBrotli(string)) as List<dynamic>)
          .map<Widget>((e) => toWidget(fromJson(e as Map<String, dynamic>)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> loadPage(String url) async {
    addLoader();
    final response = await URL().get(url);

    if (response == null || response.statusCode != 200) {
      return;
    }

    list.addAll(toWidgets(response.body));
    removeLoader();
  }

  Future<void> updateCurrentPage();
}
