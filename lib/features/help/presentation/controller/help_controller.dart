import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class HelpItem {
  final String id;
  final String titleAr;
  final String titleEn;
  final String iconAsset;
  final String action;
  final String value;

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
      iconAsset: j['icon_asset'] ?? '',
      action: j['action'] ?? 'route',
      value: j['value'] ?? '',
    );
  }
}

class HelpController extends GetxController {
  final isLoading = true.obs;
  final isError = false.obs;
  final items = <HelpItem>[].obs;

  String get _lang => 'ar';

  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.example.com',
    connectTimeout: const Duration(seconds: 12),
    receiveTimeout: const Duration(seconds: 12),
  ));

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

      final res = await _dio.get(_endpoint);
      final data = (res.data is List) ? res.data as List : [];

      final list = data.map((e) => HelpItem.fromJson(e)).toList();

      items.assignAll(list.isNotEmpty ? list : _fallback());
    } catch (_) {
      isError.value = true;
      items.assignAll(_fallback());
    } finally {
      isLoading.value = false;
    }
  }

  List<HelpItem> _fallback() => [
    HelpItem(
      id: '1',
      titleAr:ManagerStrings.helpInfo,
      titleEn: 'Help Info',
      iconAsset: 'search',
      action: 'route',
      value: '/help/info',
    ),
    HelpItem(
      id: '2',
      titleAr: ManagerStrings.termsAndPolicies,
      titleEn: 'Terms & Policies',
      iconAsset: 'target',
      action: 'route',
      value: '/help/terms',
    ),
    HelpItem(
      id: '3',
      titleAr: ManagerStrings.privacyPolicy,
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
      // launchUrlString(item.value);
        break;
      default:
      // Get.toNamed('/help/${item.value}');
        break;
    }
  }

  String titleOf(HelpItem i) => _lang == 'ar' ? i.titleAr : i.titleEn;
}
