import 'package:flutter/material.dart';

abstract class IMapper<T> {
  final int limit;
  final Widget loaderWidget;
  int currentPage = 1;
  final List<Widget> list;

  IMapper({required this.limit, required this.loaderWidget})
      : list = List.filled(limit, loaderWidget, growable: true);

  List<Widget> get _defaultList => List.filled(
        limit,
        loaderWidget,
        growable: true,
      );

  void addLoader() => list.addAll(_defaultList);

  void clear() {
    currentPage = 1;
    list.clear();
    addLoader();
  }

  void removeLoader() => list.removeWhere(
        (element) => element.runtimeType == loaderWidget.runtimeType,
      );

  List<T> stringTo(String string);
  List<Widget> toWidgets(List<T> objects);

  Future<void> updateCurrentPage({
    Function()? onSuccess,
    Function()? onFailure,
  });
}
