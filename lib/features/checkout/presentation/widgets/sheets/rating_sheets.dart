import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/routes/routes.dart';

class RatingSheets {
  static const _purple = ManagerColors.color;
  static const _green  = ManagerColors.greens;
  static const _chipBg = Color(0xFFF2F2F7);

  /// STEP 1: رضا عام (نعم/لا). بعد الاختيار ننتقل للـ Home ونمرر بارامتر لفتح الشيت التالي.
  static Future<void> showSatisfactionSheet(
      BuildContext context, {
        required String appName,
        required String orderNumber,
      }) async {
    final result = await Get.bottomSheet<bool>(
      _SatisfactionSheet(appName: appName),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    );

    if (result != null) {
      // انتقل للـ Home واطلب فتح شيت التقييم التفصيلي
      Get.back();

    }
  }

  /// STEP 2: التقييم التفصيلي (يُستدعى من الشاشة الرئيسية)
  static Future<void> showDeepRatingSheet(
      BuildContext context, {
        required String appName,
        required String orderNumber,
        required DateTime orderDate,
        bool? satisfied,
      }) async {
    final res = await Get.bottomSheet<_DeepRatingResult?>(
      _DeepRatingSheet(
        appName: appName,
        orderNumber: orderNumber,
        orderDate: orderDate,
        satisfied: satisfied,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    );

    if (res != null) {
      // TODO: أرسل res.ratings و res.comment للسيرفر إذا لزم
      await showThanksSheet(context);
    }
  }

  /// STEP 3: شيت الشكر
  static Future<void> showThanksSheet(BuildContext context) {
    return Get.bottomSheet(
      _ThanksSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    );
  }
}

/* ======================= Widgets ======================= */

class _SatisfactionSheet extends StatefulWidget {
  const _SatisfactionSheet({required this.appName});
  final String appName;

  @override
  State<_SatisfactionSheet> createState() => _SatisfactionSheetState();
}

class _SatisfactionSheetState extends State<_SatisfactionSheet> {
  bool? satisfied; // true = نعم, false = لا

  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(bottom: insets),
        child:Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // عنوان
              Row(
                children: [
                  Text(
                    " التقييم - ${widget.appName} -",
                    style:  getBoldTextStyle(
                        fontSize: 18, color: ManagerColors.black),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                  IconButton(
                    icon: const Icon(Icons.close,color: ManagerColors.black,),
                    onPressed: () => Get.back(),
                  ),





                ],
              ),
              const SizedBox(height: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    textAlign: TextAlign.start,
                    "هل أنت راضٍ عن تجربتك مع - اسم التطبيق - ؟",
                    style: getRegularTextStyle(fontSize: 14,color: ManagerColors.black),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _EmojiChoice(
                    emoji: "🙂",
                    label: "نعم",
                    selected: satisfied == true,
                    onTap: () => setState(() => satisfied = true),
                  ),
                  const SizedBox(width: 28),
                  _EmojiChoice(
                    emoji: "😐",
                    label: "لا",
                    selected: satisfied == false,
                    onTap: () => setState(() => satisfied = false),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: satisfied == null
                        ? Colors.grey.shade300
                        : RatingSheets._purple,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed:
                  satisfied == null ? null : () => Get.back(result: satisfied),
                  child:  Text(
                    "متابعة",
                    style:
                    getBoldTextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmojiChoice extends StatelessWidget {
  const _EmojiChoice({
    required this.emoji,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = selected ? RatingSheets._purple : const Color(0xFFF1F2F6);
    final labelColor = selected ? RatingSheets._purple : Colors.black54;

    return InkWell(
      borderRadius: BorderRadius.circular(56),
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bg, // الخلفية هي اللي تتغير
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 34)),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: getRegularTextStyle(
              color: labelColor,
          fontSize: 14
            ),
          ),
        ],
      ),
    );
  }
}


/* ---------- Deep rating ---------- */

class _DeepRatingSheet extends StatefulWidget {
  const _DeepRatingSheet({
    required this.appName,
    required this.orderNumber,
    required this.orderDate,
    this.satisfied,
  });

  final String appName;
  final String orderNumber;
  final DateTime orderDate;
  final bool? satisfied;

  @override
  State<_DeepRatingSheet> createState() => _DeepRatingSheetState();
}

class _DeepRatingSheetState extends State<_DeepRatingSheet> {
  final Map<String, int> ratings = {}; // 0=غير راضي,1=مقبول,2=راضي
  final ctrl = TextEditingController();

  final cats = const [
    "جودة المنتجات",
    "سرعة التسليم",
    "مندوب التوصيل",
  ];

  bool get _valid => cats.every((c) => ratings.containsKey(c));

  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(bottom: insets),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // شريط علوي
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
                Text(
                  "كيف كانت تجربة التسوق الأخيرة الخاصة بك؟",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  "تاريخ الطلب: ${_fmtDate(widget.orderDate)}  رقم الطلب: ${widget.orderNumber}",
                  style:
                  const TextStyle(color: Colors.black54, fontSize: 13.5),
                ),
                const SizedBox(height: 12),
                const Divider(),

                const SizedBox(height: 6),
                // الأسطر
                ...cats.map((c) => _ratingRow(
                  title: c,
                  value: ratings[c],
                  onChanged: (v) => setState(() => ratings[c] = v),
                )),
                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerRight,
                  child: Text("أخبرنا المزيد..",
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16)),
                ),
                const SizedBox(height: 8),

                // نص
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE6E6EB)),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: TextField(
                    controller: ctrl,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: "ما هو تعليقك؟",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      _valid ? RatingSheets._purple : Colors.grey.shade400,
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: _valid
                        ? () => Get.back(
                      result: _DeepRatingResult(
                        ratings: ratings,
                        comment: ctrl.text.trim(),
                      ),
                    )
                        : null,
                    child: const Text(
                      "حفظ وتقييم المنتجات",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _ratingRow({
    required String title,
    required int? value,
    required ValueChanged<int> onChanged,
  }) {
    final labels = ["غير راضي", "مقبول", "راضي"];
    final emojis  = ["🤢", "😐", "🙂"]; // بدّل لإيموجيزك إن لزم
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          // الخيارات
          Expanded(
            child: Wrap(
              spacing: 22,
              runSpacing: 8,
              children: List.generate(3, (i) {
                final selected = value == i;
                return InkWell(
                  borderRadius: BorderRadius.circular(48),
                  onTap: () => onChanged(i),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selected
                                ? RatingSheets._purple
                                : Colors.transparent,
                            width: 6,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: const Color(0xFFF1F2F6),
                          child: Text(emojis[i],
                              style: const TextStyle(fontSize: 22)),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        labels[i],
                        style: TextStyle(
                          color: selected
                              ? RatingSheets._purple
                              : Colors.black45,
                          fontWeight:
                          selected ? FontWeight.w700 : FontWeight.w400,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(width: 14),
          // العنوان على يمين الصورة (حسب لقطة الشاشة)
          SizedBox(
            width: 140,
            child: Text(
              title,
              textAlign: TextAlign.right,
              style:
              const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  String _fmtDate(DateTime d) =>
      "${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}";
}

class _DeepRatingResult {
  _DeepRatingResult({required this.ratings, required this.comment});
  final Map<String, int> ratings;
  final String comment;
}

/* ---------- Thanks ---------- */

class _ThanksSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("❤️", style: TextStyle(fontSize: 40)),
              const SizedBox(height: 8),
              const Text(
                "شكراً على تعليقاتك!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              const Text(
                "نحن سعداء جداً لأنك تستمتع في اسم التطبيق!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, height: 1.5),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: RatingSheets._green,
                    minimumSize: const Size.fromHeight(46),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => Get.back(),
                  child: const Text("تم",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
