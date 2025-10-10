import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:flutter/material.dart';

Future<String?> showStcPayPhoneSheet(BuildContext context) async {
  String fullNumber = '';
  String iso = 'SA';

  bool validForStcPay() {
    // السعودية: +9665######## (9 أرقام بعد الـ5)
    if (iso == 'SA') return RegExp(r'^\+9665\d{8}$').hasMatch(fullNumber);
    // للدول الأخرى (لو حبيت تسمح) طول مرن:
    return RegExp(r'^\+\d{7,15}$').hasMatch(fullNumber);
  }

  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    builder: (ctx) => StatefulBuilder(builder: (ctx, set) {
      final canContinue = validForStcPay();

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
                      margin: const EdgeInsets.only(top: 10, bottom: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDBDBDB),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),

                  const Text('أدخل رقم الهاتف المحمول',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22)),
                  const SizedBox(height: 8),
                  const Text('أدخل رقم الهاتف المحمول المسجل في STCPAY',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 14)),
                  const SizedBox(height: 14),

                  // حقل الهاتف الجاهز
                  Directionality(
                    textDirection: TextDirection.ltr, // عشان كود الدولة يبقى يسار مثل الصور
                    child: IntlPhoneField(
                      initialCountryCode: 'SA',
                      disableLengthCheck: true, // نعمل فحصنا الخاص
                      decoration: InputDecoration(
                        hintText: 'رقم الهاتف',
                        // حدود وزوايا مطابقة تقريبًا للصور
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE6E6E8), width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE6E6E8), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE6E6E8), width: 1.2),
                        ),
                      ),
                      pickerDialogStyle: PickerDialogStyle(
                        searchFieldInputDecoration: InputDecoration(
                          hintText: 'ابحث باسم الدولة أو الكود',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                      ),
                      textAlign: TextAlign.right, // النص على اليمين
                      onChanged: (PhoneNumber p) {
                        fullNumber = p.completeNumber; // +9665...
                        iso = p.countryISOCode ?? 'SA';
                        set(() {});
                      },
                      onCountryChanged: (country) {
                        iso = country.code;
                        set(() {});
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canContinue ? const Color(0xFF6CC000) : const Color(0xFFBDBDBD),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      onPressed: canContinue ? () => Navigator.pop(ctx, fullNumber) : null,
                      child: const Text('متابعة',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }),
  );
}
