// lib/features/support/presentation/view/ticket_details_view.dart
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/widgets/main_app_bar.dart';
import '../../domain/models/support_models.dart';

class TicketDetailsView extends StatelessWidget {
  const TicketDetailsView({super.key, required this.ticket});

  final SupportTicket ticket;

  @override
  Widget build(BuildContext context) {
    final t = ticket;

    sectionRow(String label, String value, {Widget? leading}) => Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              if (leading != null) ...[leading, const SizedBox(width: 6)],
              Text(label, style: getBoldTextStyle(fontSize: 14, color: Colors.black)),
            ]),
            Text(value, style: getRegularTextStyle(fontSize: 14, color: Colors.black)),
          ],
        ),
        const SizedBox(height: 12),
        Divider(height: 1, color: ManagerColors.gray_divedr, endIndent: 5,indent: 5,),

      ],
    );

    badge(String text, Color color) => Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
        child: Text(text, style: getBoldTextStyle(fontSize: 12, color: Colors.white)),
      ),
    );
    final bool isArabic = Get.locale?.languageCode == 'ar';

    return Scaffold(
      backgroundColor: ManagerColors.background,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
                onTap: () => Get.back(),
                child: SvgPicture.asset(isArabic ?ManagerImages.arrows:ManagerImages.arrow_left)),
            Text( ManagerStrings.ticket,
                style: getBoldTextStyle(color: Colors.black, fontSize: 20)),
            SizedBox(width: 30,),
          ],
        ),
        leadingWidth: 0,
        automaticallyImplyLeading: false,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFEDEDED)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(0),
            ),
            padding: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  sectionRow(ManagerStrings.clientName, '${ManagerStrings.date} : ${_fmt(t.date)}', leading: SvgPicture.asset(ManagerImages.tech_person)),
                  SizedBox(height: 10,),
                  sectionRow(ManagerStrings.orderNo, t.id, leading: SvgPicture.asset(ManagerImages.tech_reqest)),
                  SizedBox(height: 10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        SvgPicture.asset(ManagerImages.tech_switch),
                        const SizedBox(width: 6),
                        Text(ManagerStrings.orderStatus, style: getBoldTextStyle(fontSize: 14, color: Colors.black),),
                      ]),
                      badge(
                        t.status == TicketStatus.reviewing ? ManagerStrings.underReview : ManagerStrings.responded,
                        t.status == TicketStatus.reviewing ? ManagerColors.yolo : ManagerColors.grees_coll,
                      ),
                    ],
                  ),


                  const SizedBox(height: 16),
                  Divider(height: 1, color: ManagerColors.gray_divedr, endIndent: 5,indent: 5,),

                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        SvgPicture.asset(ManagerImages.tect_file),
                        const SizedBox(width: 6),
                        Text(ManagerStrings.typeProblem, style: getBoldTextStyle(fontSize: 14, color: Colors.black)),
                      ]),
                      Text('${ManagerStrings.title} (${ManagerStrings.typeProblem})', style: getRegularTextStyle(fontSize: 14, color: Colors.black)),

                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(t.details, textAlign: TextAlign.right),
                  Text(t.details, textAlign: TextAlign.right),
                  Text(t.details, textAlign: TextAlign.right),
                  Text(t.details, textAlign: TextAlign.right),
                  if (t.agentReply != null) ...[
                    const SizedBox(height: 22),

                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [

                          SvgPicture.asset(ManagerImages.tech_person_cell),
                          const SizedBox(width: 6),
                          Text(ManagerStrings.customerService, style: getBoldTextStyle(fontSize: 14, color: Colors.black)),
                        ]),
                        Text('${ManagerStrings.date} : ${_fmt(t.replyDate!)}', style: getRegularTextStyle(fontSize: 14, color: Colors.black)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAFAFA),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Column(
                        children: [
                          Text(t.agentReply!),
                          Text(t.agentReply!),
                          Text(t.agentReply!),
                          Text(t.agentReply!),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Widget _circle() => Container(
    width: 26,
    height: 26,
    decoration: BoxDecoration(
      color: const Color(0xFFF3F4F6),
      borderRadius: BorderRadius.circular(100),
    ),
  );
}
