import 'package:flutter/material.dart';
import 'package:template_project_flutter/app/core/theme/theme.dart';

class CategoryTabs extends StatefulWidget {
  final List<String> categories;
  final int initialIndex;
  final Function(int index, String category) onCategorySelected;
  final Color activeColor;
  final Color inactiveColor;
  final Color activeTextColor;
  final Color inactiveTextColor;
  final double height;
  final EdgeInsets padding;
  final double borderRadius;

  const CategoryTabs({
    super.key,
    required this.categories,
    this.initialIndex = 0,
    required this.onCategorySelected,
    this.activeColor = const Color(0xff252836),
    this.inactiveColor = Colors.transparent,
    this.activeTextColor = const Color(0xff12cdd9),
    this.inactiveTextColor = const Color(0xFFFFFFFF),
    this.height = 36,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.borderRadius = 8,
  });

  @override
  State<CategoryTabs> createState() => _CategoryTabsState();
}

class _CategoryTabsState extends State<CategoryTabs> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isActive = selectedIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              widget.onCategorySelected(index, widget.categories[index]);
            },
            child: Container(
              padding: widget.padding,
              decoration: BoxDecoration(
                color: isActive ? widget.activeColor : widget.inactiveColor,
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
              child: Center(
                child: Text(
                  widget.categories[index],
                  style: TextStyle(
                    color: isActive
                        ? widget.activeTextColor
                        : widget.inactiveTextColor,
                    fontSize: 12,
                    fontWeight: isActive ? medium : medium,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Usage
// CategoryTabs(
//   categories: const [
//     'Tab Active',
//     'Tab Inactive',
//     'Tab Inactive',
//     'Tab Inactive',
//     'Another Tab',
//   ],
//   initialIndex: 0,
//   onCategorySelected: (index, category) {
//     print('Selected: $category at index $index');
//     // Tambahkan logic Anda di sini
//   },
// )

// // Atau dengan custom styling
// CategoryTabs(
//   categories: const ['Semua', 'Elektronik', 'Fashion', 'Makanan', 'Olahraga'],
//   initialIndex: 0,
//   activeColor: Colors.blue.shade900,
//   inactiveColor: Colors.grey.shade100,
//   activeTextColor: Colors.white,
//   inactiveTextColor: Colors.grey.shade400,
//   height: 50,
//   borderRadius: 16,
//   onCategorySelected: (index, category) {
//     // Handle category change
//   },
// )
