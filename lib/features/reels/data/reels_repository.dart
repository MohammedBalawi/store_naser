import 'package:app_mobile/features/reels/data/reels_api.dart';

import 'models/reel.dart';

class ReelsRepository {
  final ReelsApi api;
  ReelsRepository(this.api);

  Future<List<Reel>> getReels({int page = 1}) => api.fetchReels(page: page);
}
