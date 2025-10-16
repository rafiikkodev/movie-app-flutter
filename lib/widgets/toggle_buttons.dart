import 'package:flutter/material.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';

class CustomToggleButtons extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const CustomToggleButtons({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      borderRadius: BorderRadius.circular(8),
      fillColor: softColor,
      splashColor: softColor,
      selectedColor: darkBlueAccent,
      color: whiteColor,
      direction: Axis.horizontal,
      borderColor: Colors.transparent,
      isSelected: List.generate(
        labels.length,
        (index) => index == selectedIndex,
      ),
      onPressed: onChanged,
      children: labels
          .map(
            (label) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                label,
                style: TextStyle(fontSize: 12, fontWeight: medium),
              ),
            ),
          )
          .toList(),
    );
  }
}
