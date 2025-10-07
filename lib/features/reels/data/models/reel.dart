import 'package:flutter/foundation.dart';

class Reel {
  final String id;
  final String cover;     // Asset أو URL
  final String title;
  final String? videoUrl; // للربط لاحقاً
  final String? shareUrl; // للربط لاحقاً

  const Reel({
    required this.id,
    required this.cover,
    required this.title,
    this.videoUrl,
    this.shareUrl,
  });

  bool get isNetwork => cover.startsWith('http');

  factory Reel.fromJson(Map<String, dynamic> j) => Reel(
    id: j['id'].toString(),
    cover: (j['cover'] ?? '').toString(),
    title: (j['title'] ?? '').toString(),
    videoUrl: j['video_url'] as String?,
    shareUrl: j['share_url'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'cover': cover,
    'title': title,
    'video_url': videoUrl,
    'share_url': shareUrl,
  };

  @override
  String toString() => describeIdentity(this);
}
