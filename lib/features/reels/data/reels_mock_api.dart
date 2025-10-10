import 'dart:async';
import 'reels_api.dart';
import 'models/reel.dart';

class ReelsMockApi implements ReelsApi {
  @override
  Future<List<Reel>> fetchReels({int page = 1}) async {
    await Future.delayed(const Duration(milliseconds: 350));
    return const [
      Reel(
        id: '1',
        // ضع نفس صورة الغلاف التي تريدها (Asset أو URL)
        cover: 'https://i.imgur.com/9QZ7Z8L.jpg',
        title: 'كريم كيلو لتجديد بشرتك - 500 جرام',
        // videoUrl: 'https://....mp4',
        // shareUrl: 'https://yourapp.com/p/1',
      ),
      Reel(
        id: '2',
        cover: 'https://i.imgur.com/9QZ7Z8L.jpg',
        title: 'جل مائي مرطّب - Hydro Boost',
      ),
    ];
  }
}
