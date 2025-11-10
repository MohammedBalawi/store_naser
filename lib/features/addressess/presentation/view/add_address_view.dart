import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../../core/resources/manager_styles.dart';
import '../controller/add_address_controller.dart';

class AddAddressView extends GetView<AddAddressController> {
  const AddAddressView({super.key});

  static const LatLng _riyadh = LatLng(24.7136, 46.6753);
  static const CameraPosition _initialCam =
  CameraPosition(target: _riyadh, zoom: 14);

  static GoogleMapController? _gMap;
  static final RxDouble _zoom = 14.0.obs;

  static final Rx<Marker> _pin = Marker(
    markerId: const MarkerId('pin'),
    position: _riyadh,
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
    infoWindow: const InfoWindow(title: 'سيتم تسليم طلبك إلى هذا الموقع'),
  ).obs;

  Future<void> _animate(CameraUpdate update) async {
    await _gMap?.animateCamera(update);
  }

  Future<void> _zoomBy(double delta) async {
    _zoom.value = (_zoom.value + delta).clamp(3.0, 20.0);
    await _animate(CameraUpdate.zoomTo(_zoom.value));
  }

  Future<void> _setPin(LatLng p, {double? zoom}) async {
    _pin.value = _pin.value.copyWith(
      positionParam: p,
      infoWindowParam: const InfoWindow(title: 'سيتم تسليم طلبك إلى هذا الموقع'),
    );
    await _animate(CameraUpdate.newLatLngZoom(p, zoom ?? _zoom.value));
    await _gMap?.showMarkerInfoWindow(const MarkerId('pin'));
  }

  Future<void> _goToMyLocation() async {
    await controller.onMyLocationTap();
    if (controller.lat != null && controller.lng != null) {
      await _setPin(LatLng(controller.lat!, controller.lng!), zoom: 16);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ManagerColors.background,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leadingWidth: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(onTap: () => Get.back(), child: SvgPicture.asset(ManagerImages.arrows)),
            Text('إضافة عنوان جديد', style: getBoldTextStyle(color: Colors.black, fontSize: 20)),
            const SizedBox(width: 42),
          ],
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFEDEDED)),
        ),
      ),

      body: Column(
        children: [
          Container(
            height: 44,
            margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            alignment: Alignment.centerRight,
            child: Obx(() => Text(
              controller.topAddress.value.isEmpty
                  ? 'MMMG+798, Al Takhassousi, Al Mathar A:'
                  : controller.topAddress.value,
              style: getRegularTextStyle(fontSize: 12, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            )),
          ),

          Expanded(
            child: Stack(
              children: [
                Obx(() => GoogleMap(
                  initialCameraPosition: _initialCam,
                  onMapCreated: (c) {
                    _gMap = c;
                    _gMap?.showMarkerInfoWindow(const MarkerId('pin'));
                  },
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  compassEnabled: false,
                  mapToolbarEnabled: false,
                  onTap: (latLng) {
                    controller.onMapTapMock(latLng); // يحدّث العنوان ويفعل الحفظ
                    _setPin(latLng, zoom: 16);
                  },
                  markers: {_pin.value},
                )),

                Positioned(
                  top: 16,
                  right: 16,
                  child: Obx(() => controller.locationOff.value
                      ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 4))],
                    ),
                    child: Row(
                      children: [
                        Text(
                          'قم بتفعيل خاصية تحديد موقعك حتى\nنستطيع تحديد مكان استلام طلبك',
                          textAlign: TextAlign.right,
                          style: getRegularTextStyle(fontSize: 12, color: Colors.black),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: controller.openAppSettings,
                          child: Text('الإعدادات', style: getBoldTextStyle(color: ManagerColors.primaryColor, fontSize: 12)),
                        ),
                      ],
                    ),
                  )
                      : const SizedBox.shrink()),
                ),

                Positioned(
                  right: 12,
                  bottom: 18 + 60,
                  child: Column(
                    children: [
                      _ZoomBtn(icon: Icons.add, onTap: () => _zoomBy(1)),
                      const SizedBox(height: 8),
                      _ZoomBtn(icon: Icons.remove, onTap: () => _zoomBy(-1)),
                    ],
                  ),
                ),

                Positioned(
                  bottom: 18 + 60,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: TextButton(
                      onPressed: _goToMyLocation,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      ),
                      child: Text('موقعي', style: getBoldTextStyle(color: ManagerColors.primaryColor, fontSize: 12)),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Obx(() => controller.showNotPrecise.value
              ? Container(
            margin: const EdgeInsets.fromLTRB(14, 8, 14, 0),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 4))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('العنوان غير دقيق، قم بتكبير الخريطة لتحديد موقعك بدقة أكبر',
                    style: getRegularTextStyle(fontSize: 12, color: Colors.black)),
                SvgPicture.asset(ManagerImages.warning)
              ],
            ),
          )
              : const SizedBox.shrink()),
          const SizedBox(height: 10),
        ],
      ),

      bottomNavigationBar: Obx(() {
        final enabled = controller.canSave.value;
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 46),
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: enabled ? controller.save : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: enabled ? ManagerColors.primaryColor : ManagerColors.color_off,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text('حفظ', style: getBoldTextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        );
      }),
    );
  }
}

class _ZoomBtn extends StatelessWidget {
  const _ZoomBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(width: 34, height: 34, child: Icon(icon, color: Colors.black, size: 20)),
      ),
    );
  }
}
