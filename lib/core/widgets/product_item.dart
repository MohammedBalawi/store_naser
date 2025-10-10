import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:app_mobile/core/cache/app_cache.dart';
import 'package:app_mobile/core/model/product_model.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/routes/routes.dart';
import 'package:app_mobile/core/service/image_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../constants/di/dependency_injection.dart';
import '../resources/manager_font_size.dart';
import '../resources/manager_height.dart';
import '../resources/manager_radius.dart';
import '../resources/manager_width.dart';

Widget productItem({
  required ProductModel model,
  bool enableCart = true,
  VoidCallback? onPriceExpired,
}) {
  return FutureBuilder(
    future: _checkAndExpirePrice(model),
    builder: (context, snapshot) {
      return GestureDetector(
        onTap: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('product_id', model.id);
          await prefs.setString('product_name', model.name ?? '');
          await prefs.setString('product_image', model.image ?? '');
          await prefs.setInt('product_price', model.price ?? 0);
          await prefs.setInt('product_rate', model.rate ?? 0);
          await prefs.setInt('product_rate_count', model.rateCount ?? 0);
          await prefs.setInt('product_favorite', model.favorite ?? 0);
          await prefs.setInt('product_quantity', model.availableQuantity ?? 0);
          await prefs.setString('product_sku', model.sku ?? '');
          await prefs.setString('product_type', model.type ?? '');
          await prefs.setInt('product_selling_price', model.sellingPrice ?? 0);
          await prefs.setInt(
              'product_discount_Ratio', model.discountRatio ?? 0);
          Get.toNamed(Routes.productDetails);
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: ManagerWidth.w8),
          width: ManagerWidth.w167,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
                color: const Color(0xFFEEEEEEEE), width: 1),
            boxShadow: [
              BoxShadow(
                color: const Color(0x0C000000),
                blurRadius: ManagerRadius.r3,
                offset: const Offset(0, 1),
              )
            ],
          ),
          child: Column(
            children: [
              SizedBox(
                height: ManagerHeight.h150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(ManagerRadius.r10),
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      // صندوق للصورة بحد من كل الجهات والصورة بالمنتصف
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 6, 10, 12),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Image(
                                  image: ImageService.networkImageContainer(
                                      path: model.image ?? ''),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // شارة زاوية مثبتة على حافة الكرت (أعلى يمين)
                      const PositionedDirectional(
                        top: 0,
                        end: 110,
                        child: CornerRibbonSimple(
                          size: 57,
                          label: 'جديد',
                        ),
                      ),

                      // ❤️ المفضلة — مثبتة أعلى يسار الكرت (مش مرتبطة بالصورة)
                      PositionedDirectional(
                        end: ManagerWidth.w10,
                        top: ManagerHeight.h12,
                        child: Container(
                          width: ManagerWidth.w36,
                          height: ManagerHeight.h36,
                          clipBehavior: Clip.antiAlias,
                          decoration: const ShapeDecoration(
                            shape: OvalBorder(),
                          ),
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return IconButton(
                                onPressed: () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  List<String> favorites =
                                      prefs.getStringList('favorites') ?? [];
                                  final productId = model.id.toString();
                                  final supabase = getIt<SupabaseClient>();
                                  final user = supabase.auth.currentUser;
                                  if (user == null) return;
                                  if (favorites.contains(productId)) {
                                    favorites.remove(productId);
                                    await prefs.setStringList(
                                        'favorites', favorites);
                                    await supabase
                                        .from('favorites')
                                        .delete()
                                        .eq('user_id', user.id)
                                        .eq('product_id', model.id);
                                  } else {
                                    favorites.add(productId);
                                    await prefs.setStringList(
                                        'favorites', favorites);
                                    await supabase.from('favorites').insert({
                                      'user_id': user.id,
                                      'product_id': model.id,
                                    });
                                  }
                                  setState(() {});
                                },
                                icon: FutureBuilder<SharedPreferences>(
                                  future: SharedPreferences.getInstance(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData)
                                      return const SizedBox();
                                    final prefs = snapshot.data!;
                                    List<String> favorites =
                                        prefs.getStringList('favorites') ?? [];
                                    final isFavorite =
                                        favorites.contains(model.id.toString());
                                    return isFavorite
                                        ? SvgPicture.asset(
                                            ManagerImages.loved,
                                            color: ManagerColors.like,
                                            width: ManagerWidth.w22,
                                          )
                                        : SvgPicture.asset(
                                            ManagerImages.favorite,
                                            width: ManagerWidth.w22,
                                          );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      PositionedDirectional(
                        bottom: 0,
                        end: 12,
                        child: _MiniCartButton(
                          width: ManagerWidth.w90,
                          height: ManagerHeight.h36,
                          maxQty: model.availableQuantity ?? 9999,
                          onChanged: (qty) {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                          right: 10,
                    top: ManagerWidth.w25,),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              top: 3, left: 5, right: 5, bottom: 5),
                          decoration: BoxDecoration(
                            color: Color(0xFFFAFAFA),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                                color: const Color(0xFFEEEEEEEE), width: 1),
                            // boxShadow: const [
                            //   BoxShadow(
                            //       color: Color(0x0F000000),
                            //       blurRadius: 8,
                            //       offset: Offset(0, 1)),
                            // ],
                          ),
                          child: Row(
                            children: [
                              FutureBuilder(
                                future: Supabase.instance.client
                                    .from('product_rates')
                                    .select('rate')
                                    .eq('product_id', model.id),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Text('0.0',
                                        style: getRegularTextStyle(
                                          fontSize: ManagerFontSize.s12,
                                          color: ManagerColors.gray_1,
                                        ));
                                  }
                                  final list = snapshot.data as List<dynamic>;
                                  if (list.isEmpty) {
                                    return Text('0.0',
                                        style: getRegularTextStyle(
                                          fontSize: ManagerFontSize.s12,
                                          color: ManagerColors.gray_1,
                                        ));
                                  }
                                  double sum = 0.0;
                                  for (var item in list) {
                                    sum += (item['rate'] as num).toDouble();
                                  }
                                  double avg = sum / list.length;
                                  return Text(
                                    avg.toStringAsFixed(1),
                                    style: getRegularTextStyle(
                                      fontSize: ManagerFontSize.s12,
                                      color: ManagerColors.gray_1,
                                    ),
                                  );
                                },
                              ),
                              SizedBox(width: ManagerWidth.w4),
                              SvgPicture.asset(ManagerImages.star),
                            ],
                          ),
                        ),
                        SizedBox(width: ManagerWidth.w7),
                        Row(
                          children: [
                            FutureBuilder(
                              future: Supabase.instance.client
                                  .from('product_rates')
                                  .select('id')
                                  .eq('product_id', model.id),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Text('0',
                                      style: getRegularTextStyle(
                                          fontSize: ManagerFontSize.s10,
                                          color: ManagerColors.gray_1));
                                }
                                final list = snapshot.data as List;
                                return Text(
                                  '(${list.length})',
                                  style: getRegularTextStyle(
                                      fontSize: ManagerFontSize.s10,
                                      color: ManagerColors.gray_1),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      model.name ?? '',
                      maxLines: 1,
                      textAlign: TextAlign.right,
                      style: getBoldTextStyle(
                          fontSize: ManagerFontSize.s12,
                          color: ManagerColors.black),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      model.sku ?? '',
                      maxLines: 2,
                      textAlign: TextAlign.right,
                      style: getRegularTextStyle(
                          fontSize: ManagerFontSize.s12,
                          color: ManagerColors.black),
                    ),
                    if ((model.sellingPrice ?? 0) > 0)
                      const SizedBox(height: 12)
                    else
                      const SizedBox(height: 12),
                    Column(
                      children: [
                        if ((model.sellingPrice ?? 0) > 0) ...[
                          Row(
                            children: [
                              Text(
                                '${model.price} ',
                                style: getRegularTextStyle(
                                  fontSize: ManagerFontSize.s12,
                                  color: ManagerColors.grey,
                                ).copyWith(decoration: TextDecoration.lineThrough),
                              ),
                              SizedBox(width: 5,),
                              Image.asset(ManagerImages.ra,height: 12,color: ManagerColors.grey,)

                            ],
                          ),
                          SvgPicture.asset(ManagerImages.ra),
                          SizedBox(width: ManagerWidth.w4),
                          Row(
                            children: [
                              Text(
                                '${model.sellingPrice}',
                                style: getBoldTextStyle(
                                  fontSize: ManagerFontSize.s14,
                                  color: ManagerColors.like,
                                ),
                              ),
                              SizedBox(width: 5,),
                              Image.asset(ManagerImages.ra,height: 12,color: ManagerColors.like,)
                            ],
                          ),
                        ] else ...[
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Row(
                              children: [
                                Text(
                                  '${model.price}',
                                  style: getBoldTextStyle(
                                    fontSize: ManagerFontSize.s14,
                                    color: ManagerColors.black,
                                  ),
                                ),
                                SizedBox(width: 5,),
                                Image.asset(ManagerImages.ra,height: 12,)

                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                  ],
                ),
              ),
              SizedBox(height: ManagerHeight.h8),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> _checkAndExpirePrice(ProductModel model) async {
  if (model.priceExpiry == null) return;
  final expiry = DateTime.tryParse(model.priceExpiry!);
  if (expiry == null || DateTime.now().isBefore(expiry)) return;

  final supabase = getIt<SupabaseClient>();
  await supabase
      .from('products')
      .update({'selling_price': 0}).eq('id', model.id);
}

// ============ زر المفضلة (مستقل وثابت مكانه) ============
class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({super.key, required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: StatefulBuilder(
        builder: (context, setState) {
          return IconButton(
            padding: EdgeInsets.zero,
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              List<String> favorites = prefs.getStringList('favorites') ?? [];
              final supabase = getIt<SupabaseClient>();
              final user = supabase.auth.currentUser;
              if (user == null) return;

              if (favorites.contains(productId.toString())) {
                favorites.remove(productId.toString());
                await prefs.setStringList('favorites', favorites);
                await supabase
                    .from('favorites')
                    .delete()
                    .eq('user_id', user.id)
                    .eq('product_id', productId);
              } else {
                favorites.add(productId.toString());
                await prefs.setStringList('favorites', favorites);
                await supabase.from('favorites').insert({
                  'user_id': user.id,
                  'product_id': productId,
                });
              }
              setState(() {});
            },
            icon: FutureBuilder<SharedPreferences>(
              future: SharedPreferences.getInstance(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox();
                final prefs = snapshot.data!;
                final favorites = prefs.getStringList('favorites') ?? [];
                final isFav = favorites.contains(productId.toString());
                return isFav
                    ? SvgPicture.asset(ManagerImages.loved,
                        color: ManagerColors.like, width: 22)
                    : SvgPicture.asset(ManagerImages.favorite, width: 22);
              },
            ),
          );
        },
      ),
    );
  }
}

// ====================== زر الكمية (نفس المنطق السابق) ======================
enum _MiniMode { bag, numberOnly, controls }

class _MiniCartButton extends StatefulWidget {
  const _MiniCartButton({
    super.key,
    required this.width,
    required this.height,
    this.maxQty = 999,
    this.onChanged,
    this.idleToNumberOnly = const Duration(seconds: 5),
    this.holdDelay = const Duration(milliseconds: 300),
    this.holdInterval = const Duration(milliseconds: 110),
  });

  final double width;
  final double height;
  final int maxQty;
  final ValueChanged<int>? onChanged;

  final Duration idleToNumberOnly;
  final Duration holdDelay;
  final Duration holdInterval;

  @override
  State<_MiniCartButton> createState() => _MiniCartButtonState();
}

class _MiniCartButtonState extends State<_MiniCartButton> {
  int _qty = 0;
  _MiniMode _mode = _MiniMode.bag;

  Timer? _idleTimer;
  Timer? _holdStarter;
  Timer? _holdRepeater;

  void _notify() => widget.onChanged?.call(_qty);

  void _setMode(_MiniMode m) {
    if (_mode != m) setState(() => _mode = m);
  }

  void _startIdleCountdown() {
    _idleTimer?.cancel();
    _idleTimer = Timer(widget.idleToNumberOnly, () {
      if (!mounted) return;
      if (_qty > 0) _setMode(_MiniMode.numberOnly);
    });
  }

  void _cancelIdle() => _idleTimer?.cancel();

  void _toControlsAndRestartIdle() {
    _setMode(_MiniMode.controls);
    _startIdleCountdown();
  }

  void _inc() {
    if (_qty < widget.maxQty) {
      setState(() => _qty++);
      _notify();
    }
  }

  void _dec() {
    if (_qty > 1) {
      setState(() => _qty--);
      _notify();
      _toControlsAndRestartIdle();
    } else if (_qty == 1) {
      setState(() {
        _qty = 0;
        _mode = _MiniMode.bag;
      });
      _cancelIdle();
      _notify();
    }
  }

  void _startHold(VoidCallback action) {
    _holdStarter?.cancel();
    _holdRepeater?.cancel();
    _holdStarter = Timer(widget.holdDelay, () {
      action();
      _holdRepeater = Timer.periodic(widget.holdInterval, (_) => action());
    });
  }

  void _stopHold() {
    _holdStarter?.cancel();
    _holdRepeater?.cancel();
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    _holdStarter?.cancel();
    _holdRepeater?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double targetWidth = switch (_mode) {
      _MiniMode.bag => widget.width,
      _MiniMode.controls => widget.width,
      _MiniMode.numberOnly => widget.height,
    };
    final BorderRadius radius = (_mode == _MiniMode.numberOnly)
        ? BorderRadius.circular(widget.height / 2)
        : BorderRadius.circular(4);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: targetWidth,
      height: widget.height,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        border: Border.all(color: const Color(0xFFE9E9E9), width: 1),
        borderRadius: radius,
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 8)],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 160),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: _buildByMode(),
        ),
      ),
    );
  }

  Widget _buildByMode() {
    switch (_mode) {
      case _MiniMode.bag:
        return InkWell(
          key: const ValueKey('bag'),
          onTap: () {
            setState(() => _qty = 1);
            _toControlsAndRestartIdle();
            _notify();
          },
          child: Center(
              child:
                  SvgPicture.asset(ManagerImages.bag_plus, width: 22, height: 22)),
        );
      case _MiniMode.numberOnly:
        return InkWell(
          key: const ValueKey('numberOnly'),
          onTap: () {
            _inc();
            _toControlsAndRestartIdle();
          },
          child: Center(
              child: Text('$_qty',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700))),
        );
      case _MiniMode.controls:
        return Row(
          key: const ValueKey('controls'),
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: _dec,
              onTapDown: (_) {
                _toControlsAndRestartIdle();
                _startHold(() {
                  if (_qty > 1) _dec();
                });
              },
              onTapUp: (_) => _stopHold(),
              onTapCancel: _stopHold,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: _qty == 1
                    ? SvgPicture.asset(ManagerImages.delete_num,
                        width: 18, height: 18)
                    : const Icon(Icons.remove, size: 18),
              ),
            ),
            Text('$_qty',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            GestureDetector(
              onTap: () {
                _inc();
                _toControlsAndRestartIdle();
              },
              onTapDown: (_) {
                _toControlsAndRestartIdle();
                _startHold(() {
                  if (_qty < widget.maxQty) _inc();
                });
              },
              onTapUp: (_) => _stopHold(),
              onTapCancel: _stopHold,
              child: const Padding(
                  padding: EdgeInsets.all(6), child: Icon(Icons.add, size: 18)),
            ),
          ],
        );
    }
  }
}

// ===== شارة زاوية بسيطة ومائلة -45° على حافة الكرت =====
class CornerRibbonSimple extends StatelessWidget {
  const CornerRibbonSimple({
    super.key,
    required this.size,
    required this.label,
  });

  final double size;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          SvgPicture.asset(
            ManagerImages.vector, // مثلث ملون
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 10,
            right: 5,
            child: Transform.rotate(
              angle: -16 / 2.9,
              child: Text(
                label.isEmpty ? 'جديد' : label,
                style: getBoldTextStyle(fontSize: 13, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
