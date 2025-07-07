import 'package:flutter/material.dart';

class ColorPickerWidget extends StatefulWidget {
  final Function(List<String>) onColorsChanged;

  const ColorPickerWidget({super.key, required this.onColorsChanged});

  @override
  State<ColorPickerWidget> createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  final Map<Color, String> colorNames = {
    Colors.red: "أحمر",
    Colors.pink: "وردي",
    Colors.purple: "بنفسجي",
    Colors.deepPurple: "بنفسجي غامق",
    Colors.indigo: "نيلي",
    Colors.blue: "أزرق",
    Colors.lightBlue: "أزرق فاتح",
    Colors.cyan: "سماوي",
    Colors.teal: "تركواز",
    Colors.green: "أخضر",
    Colors.lightGreen: "أخضر فاتح",
    Colors.lime: "ليموني",
    Colors.yellow: "أصفر",
    Colors.amber: "عنبر",
    Colors.orange: "برتقالي",
    Colors.deepOrange: "برتقالي غامق",
    Colors.brown: "بني",
    Colors.brown.shade200: "بني فاتح",
    Colors.grey: "رمادي",
    Colors.blueGrey: "رمادي مزرق",
    Colors.black: "أسود",
    Colors.white: "أبيض",
  };

  List<Color> selectedColors = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Wrap(
        spacing: 8,
        children: colorNames.keys.map((color) {
          final isSelected = selectedColors.contains(color);
          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  selectedColors.remove(color);
                } else {
                  selectedColors.add(color);
                }
                // تحديث التكسفيلد بالأسماء
                widget.onColorsChanged(selectedColors.map((c) => colorNames[c]!).toList());
              });
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.transparent,
                  width: 3,
                ),
              ),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: color,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
