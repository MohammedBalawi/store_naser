import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/resources/manager_images.dart';

/// نتيجة البطاقة المعادة بعد الإضافة
class AddedCardResult {
  final String brand;   // VISA / MASTERCARD / AMEX / MADA
  final String masked;  // ************4242
  final String last4;   // 4242
  AddedCardResult({required this.brand, required this.masked, required this.last4});
}

/// خرائط العلامات التجارية -> أصول الصور (SVG)
String _assetForBrand(String brand) {
  switch (brand.toUpperCase()) {
    case 'VISA':
      return ManagerImages.logos_visa;          // '$imagesPath/logos_visa (1).svg'
    case 'MASTERCARD':
    case 'MC':
      return ManagerImages.logos_mastercard;    // '$imagesPath/logos_mastercard.svg'
    case 'AMEX':
    case 'AMERICAN EXPRESS':
      return ManagerImages.vivs_next;           // '$imagesPath/vivs_next.svg'
    case 'MADA':
      return ManagerImages.visv_mam;            // '$imagesPath/visv_mam.svg'
    default:
      return ManagerImages.logos_visa;
  }
}

/// كبسولة الشعارات أعلى الشيت
class _NetworkChip extends StatelessWidget {
  final String brand; // 'AMEX' / 'MADA' / 'VISA' / 'MASTERCARD' or 'MC'
  const _NetworkChip(this.brand, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: SvgPicture.asset(
        _assetForBrand(brand),
        height: 16,
        fit: BoxFit.contain,
      ),
    );
  }
}

Widget _sectionTitle(String t) =>
    Text(t, style: getRegularTextStyle(fontSize: 16, color: ManagerColors.black));

class _HintText extends StatelessWidget {
  final String text;
  const _HintText(this.text, {super.key});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: getRegularTextStyle(
        color: ManagerColors.grey_2,
        fontSize: 12,
      ),
    );
  }
}

/// فورماتر رقم البطاقة: مسافة كل 4 أرقام
class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(' ', '');
    final sb = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      sb.write(digits[i]);
      if ((i + 1) % 4 == 0 && i + 1 != digits.length) sb.write(' ');
    }
    final formatted = sb.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// فورماتر الصلاحية: 1234 -> 12/34
class _ExpiryInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final d = newValue.text.replaceAll('/', '');
    String out = d;
    if (d.length > 2) out = '${d.substring(0, 2)}/${d.substring(2)}';
    return TextEditingValue(
      text: out,
      selection: TextSelection.collapsed(offset: out.length),
    );
  }
}

/// شارة الشبكة داخل حقل رقم البطاقة (على اليسار بالصورة → suffix في RTL)
Widget _brandBadge(String brand, {double height = 22}) {
  final asset = _assetForBrand(brand);
  return Padding(
    padding: const EdgeInsetsDirectional.only(start: 10, end: 6),
    child: ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      child: SvgPicture.asset(asset, height: height, fit: BoxFit.contain),
    ),
  );
}

Future<AddedCardResult?> showAddCardSheet(BuildContext context) async {
  final numberCtrl = TextEditingController();
  final expCtrl = TextEditingController();
  final cvvCtrl = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool showCvv = false;

  String detectBrand(String cleaned) {
    if (cleaned.isEmpty) return '';
    if (cleaned.startsWith('4')) return 'VISA';
    if (RegExp(r'^(5[1-5]|2[2-7])').hasMatch(cleaned)) return 'MASTERCARD';
    if (RegExp(r'^3[47]').hasMatch(cleaned)) return 'AMEX';
    // في حال BINات أخرى يمكن إعطاء mada افتراضيًا
    if (RegExp(r'^(4|5|6)').hasMatch(cleaned)) return 'MADA';
    return 'VISA';
  }

  // لاحظ: لا نستخدم Luhn في تمكين الزر؛ فقط تنسيق و أطوال صحيحة كما طلبت.
  bool _cardLengthOk(String cleaned, String brand) {
    if (brand == 'AMEX') return cleaned.length >= 15; // AMEX غالبًا 15
    return cleaned.length >= 16;                       // البقية 16
  }

  InputBorder _outline() => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
  );

  final cardFormatter = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(19),
    _CardNumberInputFormatter(),
  ];
  final expFormatter = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(4),
    _ExpiryInputFormatter(),
  ];

  return showModalBottomSheet<AddedCardResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    builder: (ctx) {
      return StatefulBuilder(builder: (ctx, set) {
        final cleaned = numberCtrl.text.replaceAll(' ', '');
        final brand = detectBrand(cleaned);
        final isAmex = brand == 'AMEX';

        bool valid() {
          final cardOk = _cardLengthOk(cleaned, brand);
          final expOk  = RegExp(r'^(0[1-9]|1[0-2])/\d{2}$').hasMatch(expCtrl.text);
          final cvvOk  = RegExp(isAmex ? r'^\d{4}$' : r'^\d{3}$').hasMatch(cvvCtrl.text);
          return cardOk && expOk && cvvOk;
        }

        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: Form(
                key: formKey,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // شريط السحب
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
                      const SizedBox(height: 2),
                      Text('إضافة بطاقة الدفع',
                          style: getBoldTextStyle(fontSize: 18, color: ManagerColors.black)),
                      const SizedBox(height: 10),

                      // صف الشعارات
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          _NetworkChip('AMEX'),
                          SizedBox(width: 6),
                          _NetworkChip('MADA'),
                          SizedBox(width: 6),
                          _NetworkChip('VISA'),
                          SizedBox(width: 6),
                          _NetworkChip('MASTERCARD'),
                        ],
                      ),
                      const SizedBox(height: 22),

                      _sectionTitle('رقم البطاقة'),
                      const SizedBox(height: 8),

                      // رقم البطاقة + شارة الشبكة (يسار الحقل في RTL)
                      TextFormField(
                        style: getRegularTextStyle(fontSize: 12, color: ManagerColors.black),
                        controller: numberCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: cardFormatter,
                        decoration: InputDecoration(
                          hintText: '',
                          suffixIcon: Padding(
                            padding: const EdgeInsetsDirectional.only(start: 12, end: 8),
                            child: cleaned.isEmpty ? const SizedBox(width: 0) : _brandBadge(brand),
                          ),
                          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                          border: _outline(),
                          enabledBorder: _outline(),
                          focusedBorder: _outline(),
                        ),
                        onChanged: (_) => set(() {}), // يحدّث لون الزر
                        validator: (v) {
                          final c = (v ?? '').replaceAll(' ', '');
                          if (!_cardLengthOk(c, brand)) return 'أدخل رقمًا صحيحًا';
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      _sectionTitle('تاريخ انتهاء الصلاحية'),
                      const SizedBox(height: 6),
                      const _HintText('MM/YY هو التنسيق'),
                      const SizedBox(height: 8),

                      TextFormField(
                        style: getRegularTextStyle(fontSize: 12, color: ManagerColors.black),
                        controller: expCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: expFormatter,
                        decoration: InputDecoration(
                          hintText: 'MM/YY',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                          border: _outline(),
                          enabledBorder: _outline(),
                          focusedBorder: _outline(),
                          suffixText: expCtrl.text.isEmpty ? '-- / --' : null,
                          suffixStyle: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w600),
                        ),
                        onChanged: (_) => set(() {}), // يحدّث لون الزر
                        validator: (v) =>
                        RegExp(r'^(0[1-9]|1[0-2])/\d{2}$').hasMatch(v ?? '') ? null : 'التنسيق هو MM/YY',
                      ),

                      const SizedBox(height: 24),

                      _sectionTitle('رمز الأمان'),
                      const SizedBox(height: 6),
                      const _HintText('رمز مكون من 3 إلى 4 أرقام على بطاقتك'),
                      const SizedBox(height: 8),

                      TextFormField(
                        style: getRegularTextStyle(fontSize: 12, color: ManagerColors.black),
                        controller: cvvCtrl,
                        keyboardType: TextInputType.number,
                        obscureText: !showCvv,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(isAmex ? 4 : 3),
                        ],
                        decoration: InputDecoration(
                          hintText: '',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                          border: _outline(),
                          enabledBorder: _outline(),
                          focusedBorder: _outline(),
                          suffixIcon: IconButton(
                            onPressed: () => set(() => showCvv = !showCvv),
                            icon: showCvv
                                ? const Icon(Icons.visibility_outlined)
                                : SvgPicture.asset(ManagerImages.close_eye),
                          ),
                          suffixText: cvvCtrl.text.isEmpty ? (isAmex ? '-- -- -- --' : '-- -- --') : null,
                          suffixStyle: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w600),
                        ),
                        onChanged: (_) => set(() {}), // يحدّث لون الزر
                        validator: (v) =>
                        RegExp(isAmex ? r'^\d{4}$' : r'^\d{3}$').hasMatch(v ?? '') ? null : 'أدخل رمزًا صحيحًا',
                      ),

                      const SizedBox(height: 22),

                      // الزر: أخضر عند الاكتمال – رمادي غير ذلك
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith((states) {
                              final can = valid();
                              if (states.contains(MaterialState.disabled) || !can) {
                                return const Color(0xFFBDBDBD); // رمادي
                              }
                              return const Color(0xFF6CC000); // أخضر
                            }),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(vertical: 16),
                            ),
                            elevation: MaterialStateProperty.all(0),
                          ),
                          onPressed: valid()
                              ? () {
                            // إرجاع النتيجة وإغلاق الـBottomSheet
                            final b = brand.isEmpty ? 'VISA' : brand;
                            final masked = '*' * (cleaned.length - 4) + cleaned.substring(cleaned.length - 4);
                            Navigator.of(ctx).pop(AddedCardResult(
                              brand: b,
                              masked: masked,
                              last4: cleaned.substring(cleaned.length - 4),
                            ));
                          }
                              : null,
                          child: const Text(
                            'إضافة بطاقة الدفع',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
    },
  );
}
