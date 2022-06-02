import 'package:flutter/material.dart';
import 'package:jais/models/simulcast.dart';

class SimulcastWidget extends StatelessWidget {
  final Simulcast simulcast;
  final bool isSelected;

  const SimulcastWidget({
    required this.simulcast,
    this.isSelected = false,
    super.key,
  });

  // Copy function
  SimulcastWidget copyWith({
    Key? key,
    Simulcast? simulcast,
    bool? isSelected,
    Function(Simulcast)? onTap,
  }) =>
      SimulcastWidget(
        key: key ?? this.key,
        simulcast: simulcast ?? this.simulcast,
        isSelected: isSelected ?? this.isSelected,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).primaryColor,
        ),
        borderRadius: BorderRadius.circular(8),
        color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Text(
            simulcast.simulcast,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : null,
            ),
          ),
        ),
      ),
    );
  }
}
