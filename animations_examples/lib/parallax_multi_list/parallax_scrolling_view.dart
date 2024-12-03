import 'package:animations_examples/parallax_multi_list/parallax_data.dart';
import 'package:animations_examples/parallax_multi_list/parallax_list_item.dart';
import 'package:flutter/material.dart';

class ParallaxScrollingView extends StatefulWidget {
  const ParallaxScrollingView({super.key});

  @override
  State<ParallaxScrollingView> createState() => _ParallaxScrollingViewState();
}

class _ParallaxScrollingViewState extends State<ParallaxScrollingView> {
  late final List<ParallaxData> parallaxItems;
  late final List<GlobalKey> globalKeys;

  @override
  void initState() {
    super.initState();
    parallaxItems = ParallaxData.initializeParallaxListWheelList();
    globalKeys = List.generate(parallaxItems.length, (_) => GlobalKey());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListWheelScrollView.useDelegate(
          itemExtent: 250,
          controller: FixedExtentScrollController(),
          childDelegate: ListWheelChildBuilderDelegate(
            childCount: parallaxItems.length,
            builder: (context, index) {
              return ParallaxListItem(
                parallaxData: parallaxItems[index],
                headImage: parallaxItems[index].imagePath,
              );
            },
          ),
        ),
      ),
    );
  }
}
