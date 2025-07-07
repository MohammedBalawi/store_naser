import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/model/color_model.dart';
import 'package:app_mobile/core/response/color_response.dart';

extension ColorMapper on ColorResponse {
  ColorModel toDomain() => ColorModel(
        id: id.onNull(),
        name: name.onNull(),
        hex: hex.onNull(),
      );
}
