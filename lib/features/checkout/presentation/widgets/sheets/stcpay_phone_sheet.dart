import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_images.dart';
import '../../../../../core/resources/manager_styles.dart';

/// نموذج دولة
class GulfCountry {
  final String name;
  final String dialCode;
  final String flagAsset;
  final String iso;
  final int minLen;

  const GulfCountry({
    required this.name,
    required this.dialCode,
    required this.flagAsset,
    required this.iso,
    required this.minLen,
  });
}

class StcPayPhoneController extends GetxController {
  final List<GulfCountry> gulfCountries = const [
    GulfCountry(name: 'السعودية', dialCode: '+966', flagAsset: ManagerImages.su, iso: 'SA', minLen: 9),
    GulfCountry(name: 'الكويت',   dialCode: '+965', flagAsset: ManagerImages.kw, iso: 'KW', minLen: 8),
    GulfCountry(name: 'الإمارات', dialCode: '+971', flagAsset: ManagerImages.ae, iso: 'AE', minLen: 9),
    GulfCountry(name: 'البحرين',  dialCode: '+973', flagAsset: ManagerImages.bh, iso: 'BH', minLen: 8),
    GulfCountry(name: 'عُمان',    dialCode: '+968', flagAsset: ManagerImages.om, iso: 'OM', minLen: 8),
    GulfCountry(name: 'قطر',      dialCode: '+974', flagAsset: ManagerImages.qa, iso: 'QA', minLen: 8),
  ];

  final Rx<GulfCountry> selected = const GulfCountry(
    name: 'السعودية',
    dialCode: '+966',
    flagAsset: ManagerImages.su,
    iso: 'SA',
    minLen: 9,
  ).obs;

  final phoneCtrl = TextEditingController();
  final focus = FocusNode();
  final hasError = false.obs;

  List<TextInputFormatter> get formatters => [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(selected.value.minLen),
  ];

  String get local => phoneCtrl.text.trim();
  String get fullNumber => '${selected.value.dialCode}${local.isEmpty ? "" : local}';

  bool get isValid {
    final s = selected.value;
    if (s.iso == 'SA') {
      return RegExp(r'^\+9665\d{8}$').hasMatch(fullNumber);
    }
    return RegExp(r'^\+\d{7,15}$').hasMatch(fullNumber);
  }

  void onChanged(String _) {
    hasError.value = false;
    if (selected.value.iso == 'SA' && local.isNotEmpty && !local.startsWith('5')) {
      hasError.value = true;
    }
    update();
  }

  void applyCountry(GulfCountry c) {
    selected.value = c;
    if (local.length > c.minLen) {
      phoneCtrl.text = local.substring(0, c.minLen);
      phoneCtrl.selection = TextSelection.collapsed(offset: phoneCtrl.text.length);
    }
    onChanged(phoneCtrl.text);
    Future.microtask(() => focus.requestFocus());
  }

  @override
  void onClose() {
    phoneCtrl.dispose();
    focus.dispose();
    super.onClose();
  }
}

Future<GulfCountry?> _pickCountryBottomSheet(
    BuildContext context, {
      required List<GulfCountry> all,
      required GulfCountry selected,
    }) {
  final RxString query = ''.obs;

  return showModalBottomSheet<GulfCountry>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    barrierColor: Colors.black54,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      final h = MediaQuery.of(ctx).size.height * 0.66;
      return Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          height: h,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 48, height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6D8FF),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 14, 12, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ManagerStrings.selectCountry
                        , style: getBoldTextStyle(fontSize: 16, color: Colors.black)),
                    const SizedBox(width: 24),
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.close, color: Colors.grey),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7FA),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE9E9EF)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      SvgPicture.asset(ManagerImages.searchIcon, color: ManagerColors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          style: getRegularTextStyle(fontSize: 14, color: ManagerColors.black),
                          onChanged: (v) => query.value = v.trim(),
                          decoration: InputDecoration(
                            hintText:ManagerStrings.searchByCountryNameOrDialingCode,
                            hintStyle: getRegularTextStyle(fontSize: 14, color: Colors.grey),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Obx(() {
                  final q = query.value;
                  final filtered = q.isEmpty
                      ? all
                      : all.where((c) {
                    final t = '${c.name} ${c.dialCode}'.toLowerCase();
                    return t.contains(q.toLowerCase());
                  }).toList();

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                    itemBuilder: (_, i) {
                      final c = filtered[i];
                      final isSel = c.dialCode == selected.dialCode;
                      return InkWell(
                        onTap: () => Navigator.pop(ctx, c),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSel ? const Color(0xFFF4ECFF) : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: isSel ? ManagerColors.color : const Color(0xFFE9E9EF)),
                          ),
                          child: Row(
                            children: [
                              Text(c.dialCode, style: getRegularTextStyle(fontSize: 16, color: Colors.black)),
                              const SizedBox(width: 10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: Image.asset(c.flagAsset, width: 24, height: 18, fit: BoxFit.cover),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  c.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: getRegularTextStyle(fontSize: 14, color: Colors.black),
                                ),
                              ),
                              if (isSel) const Icon(Icons.check_circle, color: ManagerColors.like, size: 18),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemCount: filtered.length,
                  );
                }),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<String?> showStcPayPhoneSheet(BuildContext context) async {
  final tag = 'stc-pay-${DateTime.now().microsecondsSinceEpoch}';
  final c = Get.put(StcPayPhoneController(), tag: tag);

  String? result;
  try {
    result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: ManagerColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: GetX<StcPayPhoneController>(
                tag: tag,
                builder: (ctrl) {
                  final canContinue = ctrl.isValid;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
                      Text(
                        ManagerStrings.enterMobileNumber
                          , textAlign: TextAlign.center,
                          style: getBoldTextStyle(fontSize: 18, color: Colors.black)),
                      const SizedBox(height: 18),
                      Text(ManagerStrings.enterTheMobileNumberRegisteredInSTCPAY,
                          style: getRegularTextStyle(color: Colors.black, fontSize: 14)),
                      const SizedBox(height: 24),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: ctrl.phoneCtrl,
                                focusNode: ctrl.focus,
                                keyboardType: TextInputType.number,
                                inputFormatters: ctrl.formatters,
                                decoration: InputDecoration(
                                  hintText: ManagerStrings.phone,
                                  hintStyle: getRegularTextStyle(fontSize: 16, color: ManagerColors.bongrey),
                                  border: InputBorder.none,
                                ),
                                style: getRegularTextStyle(fontSize: 16, color: ManagerColors.black),
                                onChanged: ctrl.onChanged,
                              ),
                            ),
                            const SizedBox(width: 12),
                            InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () async {
                                final pick = await _pickCountryBottomSheet(
                                  ctx,
                                  all: ctrl.gulfCountries,
                                  selected: ctrl.selected.value,
                                );
                                if (pick != null) ctrl.applyCountry(pick);
                              },
                              child: Container(
                                height: 40,
                                padding: const EdgeInsetsDirectional.only(start: 10, end: 8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.keyboard_arrow_down, size: 18, color: ManagerColors.gray_3),
                                    const SizedBox(width: 4),
                                    Text(ctrl.selected.value.dialCode,
                                        style: getMediumTextStyle(fontSize: 16, color: ManagerColors.black)),
                                    const SizedBox(width: 8),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(3),
                                      child: Image.asset(
                                        ctrl.selected.value.flagAsset,
                                        width: 24,
                                        height: 18,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (ctrl.hasError.value) ...[
                              const SizedBox(width: 8),
                              SvgPicture.asset(ManagerImages.warning),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 36),
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: canContinue ? const Color(0xFF6CC000) : const Color(0xFFBDBDBD),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 0,
                          ),
                          onPressed: canContinue
                              ? () {
                            FocusScope.of(ctx).unfocus();
                            Navigator.pop(ctx, ctrl.fullNumber);
                          }
                              : null,
                          child: Text(ManagerStrings.continues, style: getBoldTextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      ),
                      const SizedBox(height: 36),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  } finally {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<StcPayPhoneController>(tag: tag)) {
        Get.delete<StcPayPhoneController>(tag: tag, force: true);
      }
    });
  }

  return result;
}
