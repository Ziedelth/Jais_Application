import 'package:flutter/material.dart';
import 'package:jais/models/simulcast.dart';

class SimulcastWidget extends StatelessWidget {
  const SimulcastWidget({
    Key? key,
    required this.simulcast,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  final Simulcast simulcast;
  final bool isSelected;
  final Function(Simulcast)? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).primaryColor,
        ),
        borderRadius: BorderRadius.circular(8),
        color: isSelected
            ? Theme.of(context).primaryColor
            : Colors.transparent,
      ),
      child: GestureDetector(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Text(
              simulcast.simulcast,
              style: TextStyle(
                fontSize: 14,
                fontWeight:
                isSelected ? FontWeight.bold : null,
              ),
            ),
          ),
        ),
        onTap: () => onTap?.call(simulcast),
      ),
    );
  }
}
