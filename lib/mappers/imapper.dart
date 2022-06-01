import 'package:flutter/material.dart';

abstract class IMapper<T> extends ChangeNotifier {
  final int limit;
  final Widget loaderWidget;
  final list = <Widget>[];
  final scrollController = ScrollController();
  int currentPage = 1;

  IMapper(
      {required this.limit, required this.loaderWidget, bool listener = true}) {
    if (listener) {
      WidgetsBinding.instance.addPostFrameCallback((_) => updateCurrentPage());

      scrollController.addListener(() {
        if (scrollController.position.extentAfter <= 0) {
          currentPage++;
          updateCurrentPage();
        }
      });
    }
  }

  List<Widget> get _defaultList => List.filled(
        limit,
        loaderWidget,
        growable: true,
      );

  void addLoader() {
    list.addAll(_defaultList);
    notifyListeners();
  }

  void clear() {
    currentPage = 1;
    list.clear();
    addLoader();
  }

  void removeLoader() {
    list.removeWhere(
      (element) => element.runtimeType == loaderWidget.runtimeType,
    );

    notifyListeners();
  }

  List<T> stringTo(String string);
  List<Widget> toWidgets(List<T> objects);
  Future<void> updateCurrentPage();
}
