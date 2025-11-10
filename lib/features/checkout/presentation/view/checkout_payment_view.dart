import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'dart:math';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_font_size.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/widgets/main_button.dart';

import '../controller/checkout_controller.dart';
import '../widgets/checkout_stepper.dart';
import '../widgets/payment_logos_row.dart'; // يحتوي PaymentLogosRow و BrandLogo
import '../widgets/sheets/add_card_sheet.dart';
import '../widgets/sheets/otp_sheet.dart';
import '../widgets/sheets/stcpay_phone_sheet.dart';
import 'checkout_success_view.dart';

class CheckoutPaymentView extends StatelessWidget {
  const CheckoutPaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Get.locale?.languageCode == 'ar';

    return Scaffold(
      backgroundColor: ManagerColors.background,
      body: SafeArea(
        bottom: false,
        child: GetBuilder<CheckoutController>(
          builder: (c) {
            return Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: Get.back,
                          child:SvgPicture.asset(isArabic ?ManagerImages.arrows:ManagerImages.arrow_left)
                      ),
                      const Spacer(),
                      Text(ManagerStrings.orderCheckout, style: getBoldTextStyle(fontSize: ManagerFontSize.s20, color: ManagerColors.black)),
                      const Spacer(),
                      const SizedBox(width: 24),
                    ],
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: CheckoutStepper(step: 1),
                ),
                const SizedBox(height: 14),
                Divider(height: 1, thickness: 1, color: Color(0xFFEDEDED)),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
                    children:  [
                      _ProductCard(),
                      SizedBox(height: 14),
                      _SectionTitle(ManagerStrings.shippingAddress),
                      _AddressBlock(),
                      SizedBox(height: 14),
                      _SectionTitle(ManagerStrings.deliveryTime),
                      _PlainBlock(text: "من 3 إلى 4 أيام"),
                      SizedBox(height: 14),
                      _SectionTitle(ManagerStrings.couponAndDiscount),
                      _LinkBlock(text: "هل لديك قسيمة أو قسيمة؟ قدّم الآن"),
                      SizedBox(height: 14),
                      _SectionTitle(ManagerStrings.paymentWay),
                      SizedBox(height: 8),
                      _PaymentMethodsCard(),
                      SizedBox(height: 14),
                      _SectionTitle(ManagerStrings.orderSummary),
                      _SummaryBlock(),
                      SizedBox(height: 14),
                      _Text(),

                    ],
                  ),
                ),
                const SizedBox(height: 18),

              ],
            );
          },
        ),
      ),


      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: mainButton(
            buttonName: "تقديم الطلب",
            height: 56,
            color: ManagerColors.greens,
            shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            onPressed: () {
              final c = Get.find<CheckoutController>();
              if (c.selectedMethod == PaymentMethod.card) {
                // هنا ممكن تفتح شاشة 3DS أو OTP حسب بوابتك
                Get.to(() => const CheckoutSuccessView());
              } else {
                Get.to(() => const CheckoutSuccessView());
              }
            },
          ),
        ),
      ),
    );
  }
}

// ---------------- Widgets خاصة بالشاشة ----------------

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text, style: getBoldTextStyle(fontSize: 14, color: ManagerColors.black)),
      );
}

class _ProductCard extends StatelessWidget {
  const _ProductCard();

  @override
  Widget build(BuildContext context) {
    final c = Get.find<CheckoutController>();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _box(),
      child: Row(
        children: [
          // صورة المنتج
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              c.productImage,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 72,
                height: 72,
                color: Colors.grey.shade200,
                alignment: Alignment.center,
                child: const Icon(Icons.image_not_supported_outlined),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // تفاصيل
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.productTitle,
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:  getRegularTextStyle(color: Colors.black,fontSize: 14),
                ),
                const SizedBox(height: 6),
                Text(
                  " ${c.productPrice.toStringAsFixed(2)} ر.س",
                  style:  getBoldTextStyle(color: Colors.black,fontSize: 14),
                ),
                const SizedBox(height: 6),
                Text("الكمية: ${c.productQty}",
                style: getMediumTextStyle(fontSize: 14, color: Colors.black),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressBlock extends StatelessWidget {
  const _AddressBlock();

  @override
  Widget build(BuildContext context) {
    final c = Get.find<CheckoutController>();
    final a = c.addresses[c.selectedAddress];
    final bool isArabic = Get.locale?.languageCode == 'ar';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _box(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(a.name, style: getBoldTextStyle(color: ManagerColors.black, fontSize: 12)),
          const SizedBox(height: 6),
          Text(a.addressLine, textAlign: TextAlign.right, style: getMediumTextStyle(color: ManagerColors.black, fontSize: 12)),
          const SizedBox(height: 6),
          Text(a.phone, style: getMediumTextStyle(color: ManagerColors.black, fontSize: 12)),
          const SizedBox(height: 8),
          Align(
            alignment:isArabic? Alignment.centerRight :Alignment.centerLeft,
            child: Text(ManagerStrings.editTitle, style: getBoldTextStyle(color: ManagerColors.color, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

class _PlainBlock extends StatelessWidget {
  final String text;
  const _PlainBlock({required this.text});
  @override
  Widget build(BuildContext context) =>
      Container(
        padding: const EdgeInsets.all(14),
        decoration: _box(),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(text, style: getBoldTextStyle(fontSize: 12, color: ManagerColors.black)),
        ),
      );
}

class _LinkBlock extends StatelessWidget {
  final String text;
  const _LinkBlock({required this.text});
  @override
  Widget build(BuildContext context) =>
      Container(
        padding: const EdgeInsets.all(14),
        decoration: _box(),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(text, style: getBoldTextStyle(color: ManagerColors.color, fontSize: 12)),
        ),
      );
}

class _PaymentMethodsCard extends StatelessWidget {
  const _PaymentMethodsCard();

  @override
  Widget build(BuildContext context) {
    final c = Get.find<CheckoutController>();
    final bool isArabic = Get.locale?.languageCode == 'ar';

    TextStyle titleStyle = getBoldTextStyle(color: ManagerColors.black, fontSize: 10);
    TextStyle subStyle   = TextStyle(color: Colors.grey[600], fontSize: 12);

    return Container(
      decoration: _box(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 6),
            child: Row(
              children: [
                BigRadio(
                  selected: c.selectedMethod == PaymentMethod.card,
                  onTap: () => c.pickPayment(PaymentMethod.card),
                  size: 26,
                  color: Colors.black,
                  bgColor: Colors.white,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    ManagerStrings.creditMasterCard
                    ,
                    textAlign:isArabic? TextAlign.right:TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: titleStyle,
                  ),
                ),
                const SizedBox(width: 12),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 180),
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: PaymentLogosRow(codes: ["AMEX", "MADA", "VISA", "MC"]),
                  ),
                ),
              ],
            ),
          ),

          if (c.selectedMethod == PaymentMethod.card && c.cards.isNotEmpty)
            _SavedCardTile(),

          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 12, 12),
            child: Align(
              alignment:isArabic? Alignment.centerRight:Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () async {
                  final added = await showAddCardSheet(context);
                  if (added != null) {
                    c.addCard(brand: added.brand, masked: added.masked, last4: added.last4);
                  }
                },
                icon: Icon(Icons.add, color: ManagerColors.color),
                label: Text(ManagerStrings.addNewCard
                    ,
                    style: getMediumTextStyle(color: ManagerColors.color, fontSize: 12)),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFEFE3FF),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ),

          const Divider(height: 1, color: Color(0xFFEDEDED)),

          _MethodRow(
            networkBadge: 'cash_to_pay',
            title: ManagerStrings.cashOnDelivery,
            subtitle: "${ManagerStrings.serviceFee} ر.س 28",
            selected: c.selectedMethod == PaymentMethod.cod,
            onTap: () => c.pickPayment(PaymentMethod.cod),
          ),
          const Divider(height: 1, color: Color(0xFFEDEDED)),

          _MethodRow(
            networkBadge: "tabby",
            title: ManagerStrings.tabby,
            subtitle: ManagerStrings.supTabby,
            selected: c.selectedMethod == PaymentMethod.tabby,
            onTap: () async {
              c.pickPayment(PaymentMethod.tabby);
              await showOtpSheet(context, brand: "تابي");
            },
          ),
          const Divider(height: 1, color: Color(0xFFEDEDED)),

          _MethodRow(
            networkBadge: "tamara",
            title:ManagerStrings.tamara,
            subtitle: ManagerStrings.supTamara,
            selected: c.selectedMethod == PaymentMethod.tamara,
            onTap: () async {
              c.pickPayment(PaymentMethod.tamara);
              await showOtpSheet(context, brand: "تمارا");
            },
          ),
          const Divider(height: 1, color: Color(0xFFEDEDED)),

          _MethodRow(
            networkBadge: "stcpay",
            title: ManagerStrings.stcPAY,
            subtitle: "",
            selected: c.selectedMethod == PaymentMethod.stcpay,
            onTap: () async {
              c.pickPayment(PaymentMethod.stcpay);
              await showStcPayPhoneSheet(context);
            },
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}


class _SavedCardTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Get.find<CheckoutController>();
    final card = c.cards[c.selectedCardIndex];
    final bool isArabic = Get.locale?.languageCode == 'ar';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          BrandLogo(code: card.brand),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              card.masked, // ************0594
              textAlign:isArabic? TextAlign.right:TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:  getMediumTextStyle(fontSize: 14,color: Colors.black),
            ),
          ),
          const SizedBox(width: 8),
          isArabic?
          SvgPicture.asset(ManagerImages.arrows_visa_ar):
          SvgPicture.asset(ManagerImages.arrows_visa_en),
          // const Icon(Icons.chevron_left, color: Colors.black54),
        ],
      ),
    );
  }
}


class _MethodRow extends StatelessWidget {
  final IconData? icon;
  final String? networkBadge; // "tabby"/"tamara"/"stcpay"
  final String title, subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _MethodRow({
    this.icon,
    this.networkBadge,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = getBoldTextStyle(color: ManagerColors.black, fontSize: 12);
    final subStyle   = getRegularTextStyle(color: ManagerColors.gray, fontSize: 10);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(12, 10, 12, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BigRadio(
              selected: selected,
              onTap: onTap,
              size: 24,
              color: Colors.black,
              bgColor: Colors.white,
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: titleStyle, textAlign: TextAlign.right, maxLines: 1, overflow: TextOverflow.ellipsis),
                  if (subtitle.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(subtitle, style: subStyle, textAlign: TextAlign.right, maxLines: 2, overflow: TextOverflow.ellipsis),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),

          ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 100),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: (icon != null)
                    ? Icon(icon, size: 22)
                    : PaymentMethodBadge(code: networkBadge), // ← هنا
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class PaymentMethodBadge extends StatelessWidget {
  final String? code; // "tabby" | "tamara" | "stcpay" | "cod"
  final double height;

  const PaymentMethodBadge({super.key, this.code, this.height = 18});

  @override
  Widget build(BuildContext context) {
    final asset = _badgeAssetFor(code);
    if (asset == null) {
      return const Icon(Icons.payment, size: 22);
    }

    if (asset.endsWith('.svg')) {
      return SvgPicture.asset(asset, height: height);
    } else {
      return Image.asset(asset, height: height);
    }
  }

  String? _badgeAssetFor(String? c) {
    switch (c) {
      case 'cash_to_pay':
        return ManagerImages.cash_to_pay;
      case 'tabby':
        return ManagerImages.tabby;
      case 'tamara':
        return  ManagerImages.tamara; // (مثلاً: Group 1000006007.png)
      case 'stcpay':  // STC Pay
        return  ManagerImages.stc_pay;
      default:
        return null;
    }
  }
}

class _Text extends StatelessWidget {
  const _Text();

  @override
  Widget build(BuildContext context) {
    final c = Get.find<CheckoutController>();
    Text _lbl(String t) => Text(t, style:  getMediumTextStyle(color: Colors.black, fontSize: 12));
    Text _val(String t) => Text(t, style:  getMediumTextStyle(color: Colors.black, fontSize: 12));
    return Text(ManagerStrings.ifQitafIsSelected,style:getMediumTextStyle(fontSize: 12, color: ManagerColors.gray_1));
  }
}
class _SummaryBlock extends StatelessWidget {
  const _SummaryBlock();

  @override
  Widget build(BuildContext context) {
    final c = Get.find<CheckoutController>();
    Text _lbl(String t) => Text(t, style:  getMediumTextStyle(color: Colors.black, fontSize: 12));
    Text _val(String t) => Text(t, style:  getMediumTextStyle(color: Colors.black, fontSize: 12));
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _box(),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [_lbl(ManagerStrings.subTotal), _val("ر.س ${c.itemsSubtotal.toStringAsFixed(2)}")]),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [_lbl(ManagerStrings.shippingFee), _val("ر.س ${c.shipping.toStringAsFixed(2)}")]),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [_lbl(ManagerStrings.totalWithTax), _val("ر.س ${c.grandTotal.toStringAsFixed(2)}")]),
          const SizedBox(height: 8),

        ],
      ),
    );
  }
}

// ---------------- Helpers ----------------

BoxDecoration _box() => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(8),
  // border: const Border.fromBorderSide(BorderSide(color: Color(0xFFEDEDED))),
  boxShadow: [BoxShadow(color: Colors.black.withOpacity(.03), blurRadius: 6, offset: const Offset(0, 1))],
);

Widget _badge(String text) => Container(
  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
  decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(6)),
  child: Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
);



class BigRadio extends StatelessWidget {
  final bool selected;
  final VoidCallback? onTap;
  final double size;
  final Color color;
  final Color bgColor;

  const BigRadio({
    super.key,
    required this.selected,
    this.onTap,
    this.size = 26,
    this.color = Colors.black,
    this.bgColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _DoubleRingRadioPainter(
            selected: selected,
            color: color,
            bgColor: bgColor,
          ),
        ),
      ),
    );
  }
}

class _DoubleRingRadioPainter extends CustomPainter {
  final bool selected;
  final Color color;
  final Color bgColor;

  _DoubleRingRadioPainter({
    required this.selected,
    required this.color,
    required this.bgColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final r = min(size.width, size.height) / 2;
    final outerW = max(2.0, r * 0.22);
    final gapW   = max(1.8, r * 0.18);
    final center = Offset(size.width / 2, size.height / 2);

    final pOuter = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = outerW
      ..color = color;
    canvas.drawCircle(center, r - outerW / 2, pOuter);

    final pGap = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = gapW
      ..color = bgColor;
    canvas.drawCircle(center, r - outerW - gapW / 2, pGap);

    if (selected) {
      final innerRadius = max(0.0, r - outerW - gapW - (r * 0.12));
      final pInner = Paint()..color = color;
      canvas.drawCircle(center, innerRadius, pInner);
    }
  }

  @override
  bool shouldRepaint(covariant _DoubleRingRadioPainter old) =>
      old.selected != selected || old.color != color || old.bgColor != bgColor;
}
