import 'package:flutter/material.dart';
import 'package:jais/components/simulcasts/simulcast_loader_widget.dart';
import 'package:jais/components/simulcasts/simulcast_widget.dart';
import 'package:jais/mappers/imapper.dart';
import 'package:jais/models/simulcast.dart';
import 'package:jais/utils/const.dart';

class SimulcastMapper extends IMapper<Simulcast> {
  SimulcastMapper({super.listener})
      : super(
          limit: 5,
          loaderWidget: const SimulcastLoaderWidget(),
          fromJson: Simulcast.fromJson,
          toWidget: (simulcast) => SimulcastWidget(simulcast: simulcast),
        );

  @override
  Future<void> updateCurrentPage() async => loadPage(getSimulcastsUrl());

  List<Widget> toWidgetsSelected(Simulcast? simulcast) {
    if (simulcast == null) {
      return this.list;
    }

    // Copy list to avoid modifying the original list
    final list = this.list.toList();
    final index = this.list.indexWhere(
          (element) =>
              element is SimulcastWidget &&
              element.simulcast.id == simulcast.id,
        );

    if (index == -1) {
      return this.list;
    }

    // Change the same simulcast in the list to the selected simulcast
    list[index] = SimulcastWidget(simulcast: simulcast, isSelected: true);
    return list;
  }
}
