import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentLogosRow extends StatelessWidget {
  final List<String> codes; // أمثلة: ["AMEX","MADA","VISA","MC"]
  const PaymentLogosRow({super.key, required this.codes});

  static  final Map<String, String> _map = {
    'AMEX': ManagerImages.logos_mastercard,
    'MADA': ManagerImages.visv_mam,
    'VISA': ManagerImages.vivs_next,
    'MC'  : ManagerImages.visa,
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: codes.map((c) {
        final path = _map[c.toUpperCase()];
        if (path == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsetsDirectional.only(end: 8),
          child: _logo(path),
        );
      }).toList(),
    );
  }

  Widget _logo(String path) {
    final h = 20.0;
    if (path.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(path, height: h);
    } else {
      return Image.asset(path, height: h);
    }
  }
}

class BrandLogo extends StatelessWidget {
  final String code; // "VISA" | "MC" | "AMEX" | "MADA"
  const BrandLogo({super.key, required this.code});

  static const Map<String, String> _map = {
    'AMEX': ManagerImages.logos_mastercard,
    'MADA': ManagerImages.visv_mam,
    'VISA': ManagerImages.visa,
    'MC'  : ManagerImages.visa,
  };

  @override
  Widget build(BuildContext context) {
    final path = _map[code.toUpperCase()];
    if (path == null) return Text(code, style:  getBoldTextStyle(color: ManagerColors.black,fontSize: 12));
    if (path.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(path, height: 20);
    } else {
      return Image.asset(path, height: 20);
    }
  }
}
