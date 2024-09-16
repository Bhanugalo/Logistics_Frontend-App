import 'package:Logistic/constant/app_assets.dart';
import 'package:flutter/material.dart';

class TabIconData {
  TabIconData({
    this.imagePath = '',
    this.index = 0,
    this.selectedImagePath = '',
    this.isSelected = false,
    this.animationController,
  });

  String? imagePath;
  String? selectedImagePath;
  bool isSelected;
  int index;

  AnimationController? animationController;

  static List<TabIconData> tabIconsList = <TabIconData>[
    TabIconData(
      imagePath: AppAssets.icHomeUnSelected,
      selectedImagePath: AppAssets.icHomeSelected,
      index: 0,
      isSelected: true,
      animationController: null,
    ),
    TabIconData(
      imagePath: AppAssets.icSearchUnSelected,
      selectedImagePath: AppAssets.icSearchSelected,
      index: 1,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: AppAssets.icNotificationUnSelected,
      selectedImagePath: AppAssets.icNotificationSelected,
      index: 2,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: AppAssets.icMenuUnSelected,
      selectedImagePath: AppAssets.icMenuSelected,
      index: 3,
      isSelected: false,
      animationController: null,
    ),
  ];
}
