import 'package:flutter/material.dart';

abstract class IMapper<T> extends ChangeNotifier {
  final int limit;
  final Widget loaderWidget;
  final list = <Widget>[];
  final scrollController = ScrollController();
  int currentPage = 1;
  bool isLoading = false;

  IMapper({
    required this.limit,
    required this.loaderWidget,
    bool listener = true,
  }) {
    if (listener) {
      scrollController.addListener(() async {
        if (scrollController.position.extentAfter <= 0 && !isLoading) {
          isLoading = true;
          currentPage++;
          await updateCurrentPage();
          isLoading = false;
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
