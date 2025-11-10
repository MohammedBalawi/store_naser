import 'dart:async';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../../domain/model/address.dart';

class AddressesController extends GetxController {
  final items = <Address>[].obs;

  static const LatLng _riyadh = LatLng(24.7136, 46.6753);

  final cameraPos = const CameraPosition(
    target: _riyadh,
    zoom: 12,
  ).obs;

  final marker = const Marker(
    markerId: MarkerId('pin'),
    position: _riyadh,
  ).obs;

  GoogleMapController? _mapCtrl;
  final _mapReady = false.obs;

  final canUseLocation = false.obs;

  @override
  void onInit() {
    super.onInit();
    load();             // TODO: حمل عناوينك من API
    _initLocationFlag();
  }

  @override
  void onClose() {
    _mapCtrl?.dispose();
    super.onClose();
  }


  void onMapCreated(GoogleMapController c) {
    _mapCtrl = c;
    _mapReady.value = true;
  }

  void onTap(LatLng p) {
    marker.value = Marker(markerId: const MarkerId('pin'), position: p);
    cameraPos.value = CameraPosition(target: p, zoom: 15);
    _animateTo(p, 15);
  }

  Future<void> centerMyLocation() async {
    final granted = await _ensurePermission();
    if (!granted) return;

    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      final here = LatLng(pos.latitude, pos.longitude);

      marker.value = Marker(markerId: const MarkerId('pin'), position: here);
      cameraPos.value = CameraPosition(target: here, zoom: 16);

      await _animateTo(here, 16);
    } catch (_) {
    }
  }

  void add(Address a) {
    items.add(a);
  }

  void updateAddress(Address a) {
    final i = items.indexWhere((e) => e.id == a.id);
    if (i >= 0) items[i] = a;
  }

  void remove(String id) {
    items.removeWhere((e) => e.id == id);
  }

  void load() {
    items.assignAll([]);
  }


  Future<void> _animateTo(LatLng target, double zoom) async {
    if (!_mapReady.value || _mapCtrl == null) return;
    await _mapCtrl!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: zoom),
      ),
    );
  }

  Future<void> _initLocationFlag() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    var perm = await Geolocator.checkPermission();
    canUseLocation.value = serviceEnabled &&
        perm != LocationPermission.denied &&
        perm != LocationPermission.deniedForever;
  }

  Future<bool> _ensurePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      canUseLocation.value = false;
      return false;
    }

    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }

    final ok = perm != LocationPermission.denied &&
        perm != LocationPermission.deniedForever;

    canUseLocation.value = ok;
    return ok;
  }
}
