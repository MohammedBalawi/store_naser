// lib/features/addressess/presentation/widget/address_card.dart
import 'package:flutter/material.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../domain/model/address.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({
    super.key,
    required this.address,
    this.highlight = false,
    this.onEdit,
    this.onDelete,
  });

  final Address address;
  final bool highlight;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: highlight ? Border.all(color: ManagerColors.primaryColor, width: 1.5) : null,
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(address.fullName, style: getBoldTextStyle(color: Colors.black, fontSize: 14)),
          const SizedBox(height: 6),
          Text(address.prettyAddress,
              textAlign: TextAlign.right,
              style: getRegularTextStyle(fontSize: 12, color: ManagerColors.black.withOpacity(.7))),
          const SizedBox(height: 4),
          const Divider(height: 18, color: Color(0xFFEDEDED)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: onDelete, child: Text('حذف', style: getBoldTextStyle(fontSize: 14, color: ManagerColors.primaryColor))),
              const SizedBox(width: 10),
              TextButton(onPressed: onEdit, child: Text('تعديل', style: getBoldTextStyle(fontSize: 14, color: ManagerColors.primaryColor))),
            ],
          ),
        ],
      ),
    );
  }
}
