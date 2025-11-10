import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/routes/routes.dart';

class RatingSheets {
  static const _purple = ManagerColors.color;
  static const _green  = ManagerColors.greens;
  static const _chipBg = Color(0xFFF2F2F7);

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
      Get.back();

    }
  }

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


class _SatisfactionSheet extends StatefulWidget {
  const _SatisfactionSheet({required this.appName});
  final String appName;

  @override
  State<_SatisfactionSheet> createState() => _SatisfactionSheetState();
}

class _SatisfactionSheetState extends State<_SatisfactionSheet> {
  bool? satisfied;

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
              Row(
                children: [
                  Text(
                    " ${ManagerStrings.rate} - ${widget.appName} -",
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
                    ManagerStrings.areYouHappyWithYourExperience
                    ,
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
                    label: ManagerStrings.supYes,
                    selected: satisfied == true,
                    onTap: () => setState(() => satisfied = true),
                  ),
                  const SizedBox(width: 28),
                  _EmojiChoice(
                    emoji: "😐",
                    label: ManagerStrings.supNo,
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
                    ManagerStrings.continues,
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
              color: bg,
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
  final Map<String, int> ratings = {};
  final ctrl = TextEditingController();

  final cats =  [
    ManagerStrings.
    productsQuality,
    ManagerStrings.deliverySpeed,
    ManagerStrings.deliveryRepresentative,
  ];

  bool get _valid => cats.every((c) => ratings.containsKey(c));

  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.of(context).viewInsets.bottom;
    final bool isArabic = Get.locale?.languageCode == 'ar';

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(bottom: insets),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                ManagerStrings.howWasYourLastShoppingExperience,
                style:  getBoldTextStyle(
                    fontSize: 20, color: Colors.black),
              ),
              const SizedBox(height: 6),
              Text(
                "${ManagerStrings.orderDate}: ${_fmtDate(widget.orderDate)} ${ManagerStrings.orderNumber}: ${widget.orderNumber}",
                style:
                const TextStyle(color: Colors.black54, fontSize: 13.5),
              ),
              const SizedBox(height: 12),
              const Divider(),

              const SizedBox(height: 6),
              ...cats.map((c) => _ratingRow(
                title: c,
                value: ratings[c],
                onChanged: (v) => setState(() => ratings[c] = v),
              )),
              const SizedBox(height: 10),

              Align(
                alignment:isArabic? Alignment.centerRight:Alignment.centerLeft,
                child: Text(ManagerStrings.tellUsMore
                    ,
                    style:  getMediumTextStyle(
                        fontSize: 16,color: Colors.black)),
              ),
              const SizedBox(height: 8),
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
                  decoration:  InputDecoration(
                    hintText: ManagerStrings.whatIsYourFeedback,
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
                  child:  Text(
                    ManagerStrings.saveAndEvaluateProducts
                    ,
                    style: getBoldTextStyle(
                        color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
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
    final labels = [ManagerStrings.notSatisfied, ManagerStrings.decent, ManagerStrings.satisfied];
    final emojis  = ["🤢", "😐", "🙂"];
    final bool isArabic = Get.locale?.languageCode == 'ar';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
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
                        style: selected ?
                        getBoldTextStyle(
                          color: selected
                              ? RatingSheets._purple
                              : Colors.black45,
                          fontSize: 12.5,
                        ):
                getMediumTextStyle(
                          color: selected
                              ? RatingSheets._purple
                              : Colors.black45,
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
          SizedBox(
            width: 140,
            child: Text(
              title,
              textAlign:isArabic? TextAlign.right:TextAlign.left,
              style:
               getBoldTextStyle( fontSize: 16,color: Colors.black),
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
               Text(
                 ManagerStrings.thanksForYourFeedback
                ,
                style: getBoldTextStyle(fontSize: 22, color: Colors.black),
              ),
              const SizedBox(height: 8),
               Text(
                 ManagerStrings.supThanks
                ,
                textAlign: TextAlign.center,
                style: getMediumTextStyle(color: Colors.black54, fontSize: 16),
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
                  child:  Text(ManagerStrings.ok,
                      style: getBoldTextStyle(
                          color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
