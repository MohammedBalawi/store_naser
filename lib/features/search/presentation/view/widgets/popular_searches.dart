import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';

class PopularSearches extends StatelessWidget {
  PopularSearches({super.key});

  final List<String> items = [
    "Elf",
    "protein",
    "LOCA",
    "Fish oil",
    "Omega 3",
    "Nyx",
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // RTL عشان العنوان بالعربي
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان
            Text(
              'عمليات البحث الشائعة',
              style:  getBoldTextStyle(
                fontSize: 18,
                color: Colors.black
              ),
            ),

            const SizedBox(height: 16),

            // الشبكة من الأزرار
            Wrap(
              spacing: 12, // المسافة الأفقية
              runSpacing: 12, // المسافة العمودية
              children: List.generate(
                8 * items.length,
                    (index) => _buildChip(items[index % items.length]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          color: Colors.black87,
        ),
      ),
    );
  }
}
