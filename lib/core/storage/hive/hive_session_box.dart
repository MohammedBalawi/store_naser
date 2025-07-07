import 'package:hive/hive.dart';

part 'hive_session_box.g.dart';

@HiveType(typeId: 0)
class HiveSession extends HiveObject {
  @HiveField(0)
  final String accessToken;

  HiveSession({required this.accessToken});
}
