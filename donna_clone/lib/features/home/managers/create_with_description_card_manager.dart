import 'package:donna_clone/features/home/managers/create_page_manager.dart';
import 'package:donna_clone/features/home/widget/create_with_description_card.dart';
import 'package:flutter/material.dart';

mixin CreateWithDescriptionCardManager on State<CreateWithDescriptionCard>, TickerProvider {
  int activeTabIndex = 0;
  late final AnimationController controller;

  void updateActiveTab(int index) {
    setState(() {
      activeTabIndex = index;
    });
    controller.forward(from: 0.0);

    CreatePageInterited.of(context).updateCreateCardTabIndex(index);
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
