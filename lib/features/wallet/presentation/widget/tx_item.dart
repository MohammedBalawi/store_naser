import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../domain/entities/transaction.dart';

class TxItem extends StatelessWidget {
  final WalletTransaction tx;
  const TxItem({super.key, required this.tx});

  @override
  Widget build(BuildContext context) {
    final isIn = tx.type == TxType.in_;
    final amountColor = isIn ? ManagerColors.greens : ManagerColors.red_info;
    final arrow = isIn ? ManagerImages.plus : ManagerImages.maunas; // RTL: اليسار/اليمين كما بالصورة

    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.only(
        left: 0,
        right: 10
          ,
        top: 10,
        bottom: 20
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        // boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: (isIn ? Colors.green : ManagerColors.color).withOpacity(0.15),
            radius: 18,
            child: SvgPicture.asset(arrow,height: 36,),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_fmtDate(tx.createdAt),
                    style: getRegularTextStyle(color: ManagerColors.gray_3,fontSize: 12)),
                const SizedBox(height: 2),
                Text(tx.title, style: getRegularTextStyle(color: Colors.black,fontSize: 12)),
                if (tx.note != null) ...[
                  const SizedBox(height: 2),
                  Text(tx.note!, style: getRegularTextStyle(color: ManagerColors.greens,fontSize: 12)),
                ]
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 54,
            child: Text(
              ' ${tx.amount.toStringAsFixed(2)} ${isIn ? '+' : '-'}',
              style: getMediumTextStyle(color: amountColor,  fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  String _fmtDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}:${d.second.toString().padLeft(2, '0')}';
}
