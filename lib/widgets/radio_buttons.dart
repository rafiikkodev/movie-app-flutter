import 'package:flutter/material.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';

enum RadioShape { circle, square }

enum RadioDirection { horizontal, vertical }

class CustomRadioButton<T> extends StatelessWidget {
  final List<T> values;
  final T? selectedValue;
  final ValueChanged<T?> onChanged;
  final List<String> titles;
  final RadioShape shape;
  final bool isDisabled;
  final double spacing;
  final double runSpacing;
  final RadioDirection direction;

  const CustomRadioButton({
    super.key,
    required this.values,
    required this.titles,
    required this.selectedValue,
    required this.onChanged,
    this.shape = RadioShape.circle,
    this.isDisabled = false,
    this.spacing = 8.0,
    this.runSpacing = 12.0,
    this.direction = RadioDirection.vertical,
  });

  @override
  Widget build(BuildContext context) {
    if (direction == RadioDirection.horizontal) {
      return _buildHorizontalLayout();
    }
    return _buildVerticalLayout();
  }

  Widget _buildVerticalLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(values.length, (index) {
        final isLast = index == values.length - 1;
        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : runSpacing),
          child: _buildRadioItem(index),
        );
      }),
    );
  }

  Widget _buildHorizontalLayout() {
    return Wrap(
      spacing: runSpacing,
      runSpacing: runSpacing,
      children: List.generate(values.length, (index) => _buildRadioItem(index)),
    );
  }

  Widget _buildRadioItem(int index) {
    final value = values[index];
    final isSelected = selectedValue == value;

    return GestureDetector(
      onTap: isDisabled ? null : () => onChanged(value),
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRadioIndicator(isSelected),
            SizedBox(width: spacing),
            _buildLabel(index, isSelected),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioIndicator(bool isSelected) {
    return Container(
      height: 24,
      width: 24,
      decoration: BoxDecoration(
        shape: shape == RadioShape.circle
            ? BoxShape.circle
            : BoxShape.rectangle,
        borderRadius: shape == RadioShape.square
            ? BorderRadius.circular(4)
            : null,
        border: Border.all(
          color: isSelected ? darkBlueAccent : greyColor,
          width: 2,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  color: darkBlueAccent,
                  shape: shape == RadioShape.circle
                      ? BoxShape.circle
                      : BoxShape.rectangle,
                  borderRadius: shape == RadioShape.square
                      ? BorderRadius.circular(2)
                      : null,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildLabel(int index, bool isSelected) {
    return Text(
      titles[index],
      style: TextStyle(
        fontSize: 14,
        color: isSelected ? darkBlueAccent : whiteColor,
        fontWeight: medium,
      ),
    );
  }
}

// Usage

// 1. Vertical Layout (Default) dengan custom spacing
// CustomRadioButton<String>(
//   values: ['Male', 'Female', 'Other'],
//   titles: ['Male', 'Female', 'Other'],
//   selectedValue: selectedGender,
//   onChanged: (value) {
//     setState(() => selectedGender = value);
//   },
//   direction: RadioDirection.vertical,
//   spacing: 12.0,        // Jarak antara radio button dan text
//   runSpacing: 16.0,     // Jarak antar item (vertical)
//   shape: RadioShape.circle,
// )

// // 2. Horizontal Layout
// CustomRadioButton<String>(
//   values: ['Small', 'Medium', 'Large'],
//   titles: ['S', 'M', 'L'],
//   selectedValue: selectedSize,
//   onChanged: (value) {
//     setState(() => selectedSize = value);
//   },
//   direction: RadioDirection.horizontal,
//   spacing: 8.0,         // Jarak antara radio button dan text
//   runSpacing: 20.0,     // Jarak antar item (horizontal)
//   shape: RadioShape.square,
// )

// // 3. Horizontal dengan Wrap (otomatis ke baris baru)
// CustomRadioButton<int>(
//   values: [1, 2, 3, 4, 5, 6, 7, 8],
//   titles: ['1', '2', '3', '4', '5', '6', '7', '8'],
//   selectedValue: selectedNumber,
//   onChanged: (value) {
//     setState(() => selectedNumber = value);
//   },
//   direction: RadioDirection.horizontal,
//   spacing: 6.0,
//   runSpacing: 12.0,
//   shape: RadioShape.circle,
// )

// // 4. Vertical dengan spacing kecil
// CustomRadioButton<String>(
//   values: ['Option 1', 'Option 2', 'Option 3'],
//   titles: ['Option 1', 'Option 2', 'Option 3'],
//   selectedValue: selectedOption,
//   onChanged: (value) {
//     setState(() => selectedOption = value);
//   },
//   direction: RadioDirection.vertical,
//   spacing: 10.0,
//   runSpacing: 8.0,
//   shape: RadioShape.square,
// )

// // 5. Disabled State
// CustomRadioButton<String>(
//   values: ['Yes', 'No'],
//   titles: ['Yes', 'No'],
//   selectedValue: 'Yes',
//   onChanged: (value) {},
//   isDisabled: true,
//   direction: RadioDirection.horizontal,
//   spacing: 10.0,
//   runSpacing: 16.0,
// )

// // 6. Compact horizontal layout
// CustomRadioButton<String>(
//   values: ['AM', 'PM'],
//   titles: ['AM', 'PM'],
//   selectedValue: selectedTime,
//   onChanged: (value) {
//     setState(() => selectedTime = value);
//   },
//   direction: RadioDirection.horizontal,
//   spacing: 4.0,
//   runSpacing: 8.0,
//   shape: RadioShape.circle,
// )