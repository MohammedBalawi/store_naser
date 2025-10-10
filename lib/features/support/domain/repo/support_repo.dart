import '../models/support_models.dart';

abstract class SupportRepo {
  Future<List<SupportTicket>> fetchTickets();
  Future<SupportTicket> createTicket({
    required String orderId,
    required String problemTitle,
    required String details,
    String? imagePath,
  });
}
