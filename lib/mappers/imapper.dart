import 'package:flutter/material.dart';

abstract class IMapper<T> extends ChangeNotifier {
  final int limit;
  final Widget loaderWidget;
  int currentPage = 1;
  final List<Widget> list = [];

  IMapper({required this.limit, required this.loaderWidget});

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

  Future<void> updateCurrentPage({
    Function()? onSuccess,
    Function()? onFailure,
  });
}
