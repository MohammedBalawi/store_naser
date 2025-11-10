import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:app_settings/app_settings.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/model/address.dart';

class PlaceHit {
  final String title;
  final String subtitle;
  final LatLng point;
  PlaceHit({required this.title, required this.subtitle, required this.point});
}

class AddAddressController extends GetxController {
  final locationOff = true.obs;
  final topAddress = ''.obs;
  final showNotPrecise = false.obs;
  final canSave = false.obs;
  final showSheet = false.obs;

  final searchCtrl = TextEditingController();
  final isSearching = false.obs;
  final hits = <PlaceHit>[].obs;

  final nameCtrl = TextEditingController();
  final extraInfoCtrl = TextEditingController();
  final directionsCtrl = TextEditingController();
  final phone = '+966 512345678';

  double? lat;
  double? lng;

  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    _initLocationStatus();

    searchCtrl.addListener(() {
      final q = searchCtrl.text.trim();
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 350), () {
        _runSearch(q);
      });
    });
  }

  @override
  void onClose() {
    _debounce?.cancel();
    searchCtrl.dispose();
    nameCtrl.dispose();
    extraInfoCtrl.dispose();
    directionsCtrl.dispose();
    super.onClose();
  }


  void onMapTapMock(LatLng p) {
    lat = p.latitude;
    lng = p.longitude;
    showSheet.value = true;
    canSave.value = true;
    showNotPrecise.value = false;
    _reverseToTopAddress(p);
  }

  Future<void> onMyLocationTap() async {
    final ok = await _ensurePermission();
    if (!ok) return;
    await _fetchMyLocation();
    showSheet.value = true;
  }

  void onZoomIn() {}
  void onZoomOut() {}

  void setPrecisionWarning(bool v) => showNotPrecise.value = v;

  void openAppSettings() =>
      AppSettings.openAppSettings(type: AppSettingsType.location);

  Future<void> save() async {
    if (!canSave.value) return;

    final a = Address(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: nameCtrl.text.isEmpty ? 'ناصر' : nameCtrl.text,
      phone: phone,
      prettyAddress: topAddress.value.isEmpty
          ? 'Saudi Arabia., Makkah, حي الملك فهد...'
          : topAddress.value,
      isPrimary: false,
    );
    Get.back(result: a);
  }


  Future<void> _initLocationStatus() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    final perm = await Geolocator.checkPermission();
    final denied = !serviceEnabled ||
        perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever;

    locationOff.value = denied;
    if (!denied) {
      await _fetchMyLocation();
    }
  }

  Future<bool> _ensurePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      locationOff.value = true;
      return false;
    }
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) {
      locationOff.value = true;
      return false;
    }
    locationOff.value = false;
    return true;
  }

  Future<void> _fetchMyLocation() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      lat = pos.latitude;
      lng = pos.longitude;
      await _reverseToTopAddress(LatLng(lat!, lng!));
      canSave.value = true;
    } catch (_) {
      locationOff.value = true;
    }
  }

  Future<void> _reverseToTopAddress(LatLng p) async {
    String addr = '${p.latitude.toStringAsFixed(5)}, ${p.longitude.toStringAsFixed(5)}';
    try {
      final places = await geo.placemarkFromCoordinates(
        p.latitude,
        p.longitude,
        localeIdentifier: 'ar',
      );
      if (places.isNotEmpty) {
        final m = places.first;
        addr = [
          m.name,
          m.subLocality,
          m.locality,
          m.administrativeArea,
          m.country
        ].where((e) => (e ?? '').toString().trim().isNotEmpty).join(', ');
      }
    } catch (_) {}
    topAddress.value = addr;
  }

  Future<void> _runSearch(String q) async {
    if (q.isEmpty) {
      hits.clear();
      isSearching.value = false;
      return;
    }
    isSearching.value = true;
    try {
      final locs = await geo.locationFromAddress(q);
      hits.value = locs.take(5).map((l) {
        final pt = LatLng(l.latitude, l.longitude);
        return PlaceHit(
          title: q,
          subtitle:
          '${l.latitude.toStringAsFixed(5)}, ${l.longitude.toStringAsFixed(5)}',
          point: pt,
        );
      }).toList();
    } catch (_) {
      hits.clear();
    } finally {
      isSearching.value = false;
    }
  }
}
