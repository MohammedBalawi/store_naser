import '../../../../constants/constants/constants.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_strings.dart';
import 'order_status_model.dart';

OrderStatusModel orderStatusMapper({
  required String status,
}) {
  switch (status) {
    case Constants.orderStatusFinished:
      return OrderStatusModel(
        title: ManagerStrings.orderStatusFinished,
        status: Constants.orderStatusFinished,
        color: ManagerColors.statusFinished,
      );
    case Constants.orderStatusPending:
      return OrderStatusModel(
        title: ManagerStrings.orderStatusPending,
        status: Constants.orderStatusPending,
        color: ManagerColors.statusPending,
      );
    case Constants.orderStatusCancelled:
      return OrderStatusModel(
        title: ManagerStrings.orderStatusCancelled,
        status: Constants.orderStatusCancelled,
        color: ManagerColors.statusCancelled,
      );
    default:
      return OrderStatusModel(
        title: ManagerStrings.orderStatusFinished,
        status: Constants.orderStatusFinished,
        color: ManagerColors.statusFinished,
      );
  }
}
