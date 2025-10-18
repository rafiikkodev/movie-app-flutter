import 'package:flutter/material.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';

enum RadioShape { circle, square }

class CustomRadioButton<T> extends StatefulWidget {
  final List<T> values;
  final T? selectedValue;
  final ValueChanged<T?> onChanged;
  final List<String> titles;
  final RadioShape shape;
  final bool isDisabled;

  const CustomRadioButton({
    super.key,
    required this.values,
    required this.titles,
    required this.selectedValue,
    required this.onChanged,
    this.shape = RadioShape.circle,
    this.isDisabled = false,
  });

  @override
  State<CustomRadioButton<T>> createState() => _CustomRadioButtonState<T>();
}

class _CustomRadioButtonState<T> extends State<CustomRadioButton<T>> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.values.length, (index) {
        final value = widget.values[index];
        final isSelected = widget.selectedValue == value;

        return GestureDetector(
          onTap: widget.isDisabled ? null : () => widget.onChanged(value),
          child: Opacity(
            opacity: widget.isDisabled ? 0.5 : 1.0,
            child: Row(
              children: [
                Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    shape: widget.shape == RadioShape.circle
                        ? BoxShape.circle
                        : BoxShape.rectangle,
                    borderRadius: widget.shape == RadioShape.square
                        ? BorderRadius.circular(4)
                        : null,
                    border: Border.all(
                      color: isSelected ? darkBlueAccent : whiteColor,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            height: 16,
                            width: 16,
                            decoration: BoxDecoration(
                              color: darkBlueAccent,
                              shape: widget.shape == RadioShape.circle
                                  ? BoxShape.circle
                                  : BoxShape.rectangle,
                              borderRadius: widget.shape == RadioShape.square
                                  ? BorderRadius.circular(4)
                                  : null,
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.titles[index],
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? darkBlueAccent : whiteColor,
                    fontWeight: medium,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
