import 'dart:async';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/state_manager.dart';

Future<void> showOtpSheet(BuildContext context, {required String brand}) async {
  // ألوان/ثوابت
  const cardBorder = Color(0xFFE5E7EB);
  const cardShadow = Color(0x0F000000);
  const track = Color(0xFFEDF2F7);

  final purple = ManagerColors.color;   // البنفسجي حسب الثيم عندك
  final green  = ManagerColors.greens;  // الأخضر للزر

  // هل هي تمارا؟
  final isTamara = brand.trim() == 'تمارا' || brand.toLowerCase().contains('tamara');

  // OTP
  final c1 = TextEditingController();
  final c2 = TextEditingController();
  final c3 = TextEditingController();
  final c4 = TextEditingController();
  final f1 = FocusNode(), f2 = FocusNode(), f3 = FocusNode(), f4 = FocusNode();

  bool accepted = false;
  int seconds = 26;
  Timer? timer;

  bool _allFilled() =>
      c1.text.isNotEmpty && c2.text.isNotEmpty && c3.text.isNotEmpty && c4.text.isNotEmpty;
  bool _canContinue() => accepted && _allFilled();

  void startTimer(VoidCallback tick) {
    timer?.cancel();
    seconds = 26;
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (seconds == 0) t.cancel(); else seconds--;
      tick();
    });
  }

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFFF7F7FA),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (ctx) {
      return StatefulBuilder(builder: (ctx, set) {
        timer ?? startTimer(() => set(() {}));

        // صندوق خانة OTP
        Widget _otpBox(TextEditingController c, FocusNode f, FocusNode? next, FocusNode? prev) {
          return SizedBox(
            width: 70, height: 70,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: cardBorder),
              ),
              alignment: Alignment.center,
              child: TextField(
                controller: c,
                focusNode: f,
                textAlign: TextAlign.center,
                style: getBoldTextStyle(fontSize: 16, color: ManagerColors.black),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(1),
                ],
                decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                onChanged: (v) {
                  // دعم اللصق لأكثر من رقم
                  if (v.length > 1) {
                    final d = v.replaceAll(RegExp(r'\D'), '');
                    if (d.isNotEmpty) c1.text = d[0];
                    if (d.length > 1) c2.text = d[1];
                    if (d.length > 2) c3.text = d[2];
                    if (d.length > 3) c4.text = d[3];
                    if (d.length >= 4) FocusScope.of(ctx).unfocus();
                    set(() {});
                    return;
                  }
                  if (v.isNotEmpty && next != null) {
                    FocusScope.of(ctx).requestFocus(next);
                  } else if (v.isEmpty && prev != null) {
                    FocusScope.of(ctx).requestFocus(prev);
                  }
                  set(() {});
                },
              ),
            ),
          );
        }

        // ترويسة أعلى الشيت: العربية | اسم التطبيق | X + شريط الخطوات
        Widget _sheetHeader() => Column(
          children: [
            Row(
              children: [
                // إغلاق
                IconButton(
                  onPressed: () { timer?.cancel(); Navigator.pop(ctx); },
                  icon: Icon(Icons.close, size: 24, color: ManagerColors.black),
                ),
                const Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline, size: 20, color: ManagerColors.gray_1),
                            const SizedBox(width: 6),
                            Text('اسم التطبيق',
                                style: getBoldTextStyle(fontSize: 16, color: ManagerColors.black)),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(isTamara ? 'ادفع بواسطة تمارا' : 'ادفع بواسطة تابـي',
                            style: getMediumTextStyle(color: ManagerColors.gray, fontSize: 14)),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Text('العربية', style: getMediumTextStyle(color: purple, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    top: 20,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(height: 0.5, color: ManagerColors.lins),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _StepIcon(icon: ManagerImages.mobayle),
                        _StepIcon(icon: ManagerImages.id),
                        _StepIcon(icon: ManagerImages.card_cash),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

        // كرت رقم الهاتف (Tamara)
        Widget _tamaraPhoneCard() => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('تمارا', style: getBoldTextStyle(color: ManagerColors.black, fontSize: 16)),

                Text('العربية', style: getMediumTextStyle(color: ManagerColors.color, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 10),
            Text('التحقق من رقمك',
                textAlign: TextAlign.right,
                style: getBoldTextStyle(color: ManagerColors.black, fontSize: 20)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: cardBorder),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(ManagerImages.proicons_phone,),
                      SizedBox(width: 10,),
                      Text('+966 512345678',
                          style: getMediumTextStyle(color: ManagerColors.black, fontSize: 14)),

                    ],
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(right: 35.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text('تغيير الرقم؟',
                          style: getRegularTextStyle(color: purple, fontSize: 14)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Text('لقد أرسلنا للتو رمز التحقق عبر الرسائل القصيرة.',
                textAlign: TextAlign.right,
                style: getRegularTextStyle(color: ManagerColors.gray, fontSize: 14)),
          ],
        );

        // نص أعلى الخانات (Tabby)
        Widget _tabbyHeader() => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('تابي', style: getBoldTextStyle(color: ManagerColors.black, fontSize: 16)),
                Text('العربية', style: getMediumTextStyle(color: purple, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 10),
            Text('التحقق من الرمز المكون من 4 أرقام',
                textAlign: TextAlign.right,
                style: getBoldTextStyle(color: ManagerColors.black, fontSize: 20)),
            const SizedBox(height: 12),
            RichText(
              textAlign: TextAlign.right,
              text: TextSpan(
                style: getRegularTextStyle(color: ManagerColors.black, fontSize: 14),
                children: [
                  const TextSpan(text: 'أُرسل إلى رقم الهاتف المنتهي بـ '),
                  TextSpan(text: '*6325',
                      style: getRegularTextStyle(color: ManagerColors.black, fontSize: 14)),
                  const TextSpan(text: ' أو عبر إشعار فوري. '),
                  TextSpan(text: 'غير الحساب.',
                      style: getRegularTextStyle(color: purple, fontSize: 14)),
                ],
              ),
            ),
          ],
        );

        // شروط وأحكام (تمارا مبسّطة / تابي موسعة)
        Widget _termsRow() {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: accepted,
                onChanged: (v) => set(() => accepted = v ?? false),
                activeColor: ManagerColors.color,
                side: const BorderSide(color: Colors.grey, width: 1.4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: isTamara
                      ? RichText(
                    textAlign: TextAlign.right,
                    text: TextSpan(
                      style: getRegularTextStyle(color: ManagerColors.gray, fontSize: 16),
                      children: [
                        const TextSpan(text: 'أوافق على '),
                        TextSpan(
                          text: 'شروط وأحكام ',
                          style: getBoldTextStyle(color: ManagerColors.black, fontSize: 16)
                              .merge(const TextStyle(decoration: TextDecoration.underline)),
                        ),
                        const TextSpan(text: 'تمارا'),
                      ],
                    ),
                  )
                      : RichText(
                    textAlign: TextAlign.right,
                    text: TextSpan(
                      style: getRegularTextStyle(color: ManagerColors.gray, fontSize: 16),
                      children: [
                        const TextSpan(text: 'أوافق على '),
                        TextSpan(
                          text: 'شروط وأحكام ',
                          style: getBoldTextStyle(color: ManagerColors.black, fontSize: 16),
                        ),
                        const TextSpan(text: 'Tabby '),
                        TextSpan(
                          text: 'وسياسة ',
                          style: getBoldTextStyle(color: ManagerColors.black, fontSize: 16),
                        ),
                        TextSpan(
                          text: 'الخصوصية',
                          style: getBoldTextStyle(color: ManagerColors.black, fontSize: 16),
                        ),
                        const TextSpan(text: '، وأوافق على '),
                        TextSpan(
                          text: 'معالجة بياناتي',
                          style: getBoldTextStyle(color: ManagerColors.black, fontSize: 16),
                        ),
                        const TextSpan(text: '\n'),
                        TextSpan(
                          text: 'الشخصية',
                          style: getBoldTextStyle(color: ManagerColors.black, fontSize: 16),
                        ),
                        TextSpan(
                          text: '، بما في ذلك الاستفسار عن \n',
                          style: getRegularTextStyle(color: ManagerColors.gray, fontSize: 16),
                        ),
                        TextSpan(
                          text: 'معلومات الائتمان الخاصة بي ومشاركتها مع \n',
                          style: getRegularTextStyle(color: ManagerColors.gray, fontSize: 16),
                        ),
                        TextSpan(
                          text: '|SIMAH',
                          style: getRegularTextStyle(color: ManagerColors.gray, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // مقبض السحب
                    Center(
                      child: Container(
                        width: 90, height: 6,
                        margin: const EdgeInsets.only(top: 6, bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),

                    _sheetHeader(),
                    const SizedBox(height: 16),

                    // البطاقة البيضاء الرئيسية
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: cardBorder),
                        boxShadow: const [BoxShadow(color: cardShadow, blurRadius: 12, offset: Offset(0, 1))],
                      ),
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (isTamara) _tamaraPhoneCard() else _tabbyHeader(),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _otpBox(c1, f1, f2, null),
                              _otpBox(c2, f2, f3, f1),
                              _otpBox(c3, f3, f4, f2),
                              _otpBox(c4, f4, null, f3),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Align(
                            alignment: Alignment.centerRight,
                            child: seconds > 0
                                ? Text('أُرسل رمزًا آخر  00:${seconds.toString().padLeft(2, '0')}',
                                style: getRegularTextStyle(color: ManagerColors.gray, fontSize: 16))
                                : InkWell(
                              onTap: () => startTimer(() => set(() {})),
                              child: Text('أرسل رمزًا آخر',
                                  style: getRegularTextStyle(color: ManagerColors.color, fontSize: 16)),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    _termsRow(),
                    const SizedBox(height: 12),

                    // زر المتابعة
                    SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _canContinue() ? green : const Color(0xFFD1D5DB),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        onPressed: _canContinue()
                            ? () { timer?.cancel(); Navigator.pop(ctx); }
                            : null,
                        child: Text('المتابعة',
                            style: getBoldTextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        );
      });
    },
  );

  timer?.cancel();
}

class _StepIcon extends StatelessWidget {
  final String icon;
  final bool active;
  const _StepIcon({required this.icon, this.active = false});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(icon, height: 24);
  }
}
