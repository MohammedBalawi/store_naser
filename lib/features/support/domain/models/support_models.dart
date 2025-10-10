enum TicketStatus { reviewing, replied }

class SupportTicket {
  final String id;            // رقم الطلب 26579639
  final String customerName;  // اسم العميل
  final DateTime date;        // التاريخ
  final String problemTitle;  // نوع المشكلة (نص قصير)
  final TicketStatus status;  // قيد المراجعة / تم الرد
  final String details;       // وصف طويل
  final String? agentReply;   // رد خدمة العملاء (اختياري)
  final DateTime? replyDate;  // تاريخ الرد (اختياري)

  SupportTicket({
    required this.id,
    required this.customerName,
    required this.date,
    required this.problemTitle,
    required this.status,
    required this.details,
    this.agentReply,
    this.replyDate,
  });
}
