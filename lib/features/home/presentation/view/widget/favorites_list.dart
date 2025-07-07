import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../core/model/product_model.dart';
import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_height.dart';
import '../../../../../core/resources/manager_radius.dart';
import '../../../../../core/service/image_service.dart';

class FavoritesListWheel extends StatefulWidget {
  final List<ProductModel> items;

  const FavoritesListWheel({super.key, required this.items});

  @override
  State<FavoritesListWheel> createState() => _FavoritesListWheelState();
}

class _FavoritesListWheelState extends State<FavoritesListWheel> {
  final FixedExtentScrollController _controller = FixedExtentScrollController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return false;
      if (widget.items.isEmpty) return true;
      _currentIndex = (_currentIndex + 1) % widget.items.length;
      _controller.animateToItem(_currentIndex,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.items.isNotEmpty ? widget.items : [];

    return SizedBox(
      height: ManagerHeight.h300,
      // width: ManagerWidth.w30,
      child: ListWheelScrollView.useDelegate(
        controller: _controller,
        itemExtent: 200,
        physics: const FixedExtentScrollPhysics(),
        magnification: 1.1,
        useMagnifier: true,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: data.length,
          builder: (context, index) {
            final item = data[index];
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                margin: const EdgeInsetsDirectional.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ManagerColors.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(
                      item.image ?? '',
                    ),
                    // fit: BoxFit.cover,
                    fit:  BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: ManagerColors.primaryColor.withOpacity(0.4),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),

              ),
            );
          },
        ),
      ),
    );
  }
}
