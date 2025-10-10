import 'package:dio/dio.dart';
import 'package:get/get.dart';

class HelpItem {
  final String id;
  final String titleAr;      // العنوان بالعربي
  final String titleEn;      // العنوان بالإنجليزي (لو بدك لاحقًا)
  final String iconAsset;    // مسار الأيقونة (svg/png) من ManagerImages
  final String action;       // نوع الإجراء: route / url / slug
  final String value;        // قيمة الإجراء: مسار الراوت أو رابط خارجي

  HelpItem({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.iconAsset,
    required this.action,
    required this.value,
  });

  factory HelpItem.fromJson(Map<String, dynamic> j) {
    return HelpItem(
      id: '${j['id']}',
      titleAr: j['title_ar'] ?? '',
      titleEn: j['title_en'] ?? '',
      iconAsset: j['icon_asset'] ?? '',   // احفظ اسم الأيقونة (ونحوّلها لاحقًا لمدير الصور)
      action: j['action'] ?? 'route',
      value: j['value'] ?? '',
    );
  }
}

class HelpController extends GetxController {
  // ======= حالة الشاشة =======
  final isLoading = true.obs;
  final isError = false.obs;
  final items = <HelpItem>[].obs;

  // لو عندك لغة منPrefs/Localization غيّرها
  String get _lang => 'ar';

  // ======= الشبكة =======
  final Dio _dio = Dio(BaseOptions(
    // غيّرها لباك-إندك
    baseUrl: 'https://api.example.com',
    connectTimeout: const Duration(seconds: 12),
    receiveTimeout: const Duration(seconds: 12),
  ));

  // endpoint المقترح: GET /help/links
  static const _endpoint = '/help/links';

  @override
  void onInit() {
    super.onInit();
    fetchItems();
  }

  Future<void> fetchItems() async {
    try {
      isLoading.value = true;
      isError.value = false;

      // استبدل الطلب حسب باك-إندك:
      final res = await _dio.get(_endpoint);
      final data = (res.data is List) ? res.data as List : [];

      final list = data.map((e) => HelpItem.fromJson(e)).toList();

      // fallback لو الباك-إند لسه مش جاهز — نفس العناصر اللي بالصورة
      items.assignAll(list.isNotEmpty ? list : _fallback());
    } catch (_) {
      isError.value = true;
      // fallback للعرض المحلي حتى تبني الـ API
      items.assignAll(_fallback());
    } finally {
      isLoading.value = false;
    }
  }

  // عناصر افتراضية مطابقة للصورة (الترتيب مهم)
  List<HelpItem> _fallback() => [
    HelpItem(
      id: '1',
      titleAr: 'معلومات المساعدة',
      titleEn: 'Help Info',
      iconAsset: 'search', // Name سنحوّله لمدير الصور في الـ View
      action: 'route',
      value: '/help/info',
    ),
    HelpItem(
      id: '2',
      titleAr: 'الشروط والسياسات',
      titleEn: 'Terms & Policies',
      iconAsset: 'target',
      action: 'route',
      value: '/help/terms',
    ),
    HelpItem(
      id: '3',
      titleAr: 'سياسة الخصوصية',
      titleEn: 'Privacy Policy',
      iconAsset: 'privacy',
      action: 'route',
      value: '/help/privacy',
    ),
  ];

  void onTapItem(HelpItem item) {
    switch (item.action) {
      case 'route':
        if (item.value.isNotEmpty) {
          Get.toNamed(item.value);
        }
        break;
      case 'url':
      // افتح WebView أو launchUrl
      // launchUrlString(item.value);
        break;
      default:
      // slug مخصص
      // Get.toNamed('/help/${item.value}');
        break;
    }
  }

  String titleOf(HelpItem i) => _lang == 'ar' ? i.titleAr : i.titleEn;
}
