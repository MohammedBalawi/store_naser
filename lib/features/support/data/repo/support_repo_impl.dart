import 'dart:async';
import '../../domain/models/support_models.dart';
import '../../domain/repo/support_repo.dart';

class SupportRepoImpl implements SupportRepo {
  final _store = <SupportTicket>[
    SupportTicket(
      id: '26579639',
      customerName: 'اسم العميل',
      date: DateTime(2024, 1, 25),
      problemTitle: 'تلقيت طلبًا خاطئًا',
      status: TicketStatus.reviewing,
      details: 'لوريم ايبسوم ...',
    ),
    SupportTicket(
      id: '26579639',
      customerName: 'اسم العميل',
      date: DateTime(2024, 1, 25),
      problemTitle: 'تلقيت طلبًا خاطئًا',
      status: TicketStatus.replied,
      details: 'لوريم ايبسوم ...',
      agentReply: 'لوريم ايبسوم لوريم ايبسوم لوريم ايبسوم ...',
      replyDate: DateTime(2025, 1, 25),
    ),
  ];

  @override
  Future<List<SupportTicket>> fetchTickets() async {
    await Future.delayed(const Duration(milliseconds: 450));
    return _store;
  }

  @override
  Future<SupportTicket> createTicket({
    required String orderId,
    required String problemTitle,
    required String details,
    String? imagePath,
  }) async {
    await Future.delayed(const Duration(milliseconds: 450));
    final t = SupportTicket(
      id: orderId,
      customerName: 'اسم العميل',
      date: DateTime.now(),
      problemTitle: problemTitle,
      status: TicketStatus.reviewing,
      details: details,
    );
    _store.insert(0, t);
    return t;
  }
}
