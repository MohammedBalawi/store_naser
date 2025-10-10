import 'package:app_mobile/features/support/presentation/view/ticket_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../../core/resources/manager_styles.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/widgets/main_app_bar.dart';
import '../../domain/models/support_models.dart';
import '../controller/tickets_controller.dart';

class TechSupportView extends GetView<TicketsController> {
  const TechSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ManagerColors.background,
      appBar:

      AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text('الدعم الفني',
            style: getBoldTextStyle(color: Colors.black, fontSize: 20)),
        actions: [
          GestureDetector(
              onTap:(){
                Get.toNamed(Routes.openTicket);
              },child: SvgPicture.asset(ManagerImages.icon_add)),
          SizedBox(width: 10,),

        ],
        leading:   GestureDetector(
            onTap: () => Get.back(),
            child: SvgPicture.asset(ManagerImages.arrows)),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFEDEDED)),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.tickets.isEmpty) {
          // الحالة الفارغة
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(ManagerImages.ticket, width: 60, height: 60, colorFilter: const ColorFilter.mode(ManagerColors.color, BlendMode.srcIn)),
              const SizedBox(height: 16),
              Text('لا توجد تذكرة', style: getBoldTextStyle(fontSize: 18, color: ManagerColors.black)),
              const SizedBox(height: 20),
              _PrimaryButton(label: 'فتح تذكرة', onPressed: () => Get.toNamed('/support/open-ticket')),
            ],
          );
        }
        // قائمة تذاكر
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
          itemCount: controller.tickets.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) => _TicketCard(t: controller.tickets[i]),
        );
      }),
    );
  }
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({required this.t});
  final SupportTicket t;

  String _statusText(TicketStatus s) => s == TicketStatus.reviewing ? 'قيد المراجعة' : '     تم الرد       ';
  Color _statusColor(TicketStatus s) => s == TicketStatus.reviewing ?ManagerColors.yolo : ManagerColors.grees_coll;

  @override
  Widget build(BuildContext context) {
    text(String label, Widget? value, {Widget? icon}) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          if (icon != null) icon,
          SizedBox(width: 10,),
          Text(label, style: getBoldTextStyle(fontSize: 14, color: ManagerColors.black)),
          const SizedBox(width: 6),

        ]),
        if (value != null) value,



      ],
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 28.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 15),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0,left: 12,right:12,bottom: 12 ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
            text('اسم العميل',
      Text('التاريخ : ${_fmt(t.date)}', textAlign: TextAlign.left, style: getRegularTextStyle(fontSize: 14, color: ManagerColors.black)),
                icon: SvgPicture.asset(ManagerImages.tech_person)),
            SizedBox(height: 10,),
                Divider(height: 1, color: ManagerColors.gray_divedr, endIndent: 5,indent: 5,),

                SizedBox(height: 10,),

            text('رقم الطلب',
      Text(t.id, textAlign: TextAlign.left, style: getRegularTextStyle(fontSize: 14, color: ManagerColors.black))
      , icon:SvgPicture.asset(ManagerImages.tech_reqest)),
                SizedBox(height: 10,),

                Divider(height: 1, color: ManagerColors.gray_divedr, endIndent: 5,indent: 5,),

                SizedBox(height: 10,),

            text('نوع المشكلة',
                Text(t.problemTitle, textAlign: TextAlign.left, style: getRegularTextStyle(fontSize: 14, color: ManagerColors.black))

                , icon:SvgPicture.asset(ManagerImages.tect_file)),
                SizedBox(height: 10,),

                Divider(height: 1, color: ManagerColors.gray_divedr, endIndent: 5,indent: 5,),

                SizedBox(height: 10,),
                text('حالة الطلب', Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: _statusColor(t.status), borderRadius: BorderRadius.circular(8)),
                    child: Text(_statusText(t.status), style: getBoldTextStyle(fontSize: 12, color: Colors.white)),
                  ),
                ), icon:
                SvgPicture.asset(ManagerImages.tech_switch)
                ),


            const SizedBox(height: 14),
            _PrimaryButton(
              label: 'عرض',
              onPressed: () =>
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TicketDetailsView(ticket: t,),
                    ),
                  ),

            ),
          ]),
        ),
      ),
    );
  }

  String _fmt(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: ManagerColors.color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
        ),
        child: Text(label, style: getBoldTextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }
}
