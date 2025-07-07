import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OptionsController extends GetxController {
  late int selectedColorIndex = 0;

  late int selectedSizeIndex = 0;

  late int selectedShoeSizeIndex = 0;

  final List<Color> colorOption = <Color>[
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.black,
    Colors.grey,
    Colors.pink,
    Colors.red,
  ];

  final List<String> size = <String>[
    'S',
    'M',
    'L',
    'XL',
    'XXL',
  ];

  final List<String> sizeShoes = <String>[
    '35',
    '36',
    '37',
    '38',
    '39',
    '40',
    '41',
    '42',
    '43',
    '44',
    '45',
    '46',
    '47',
  ];

  void updateColorIndex(int index) {
    selectedColorIndex = index;
    update();
  }

  void updateSizeIndex(int index) {
    selectedSizeIndex = index;
    update();
  }

  void updateShoeSizeIndex(int index) {
    selectedShoeSizeIndex = index;
    update();
  }
}
