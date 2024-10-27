import 'package:donna_clone/app/components/base_animated_list_view.dart';
import 'package:flutter/material.dart';

class AppAnimatedListView<T> extends StatelessWidget {
  const AppAnimatedListView({super.key, required this.items, required this.itemBuilder});

  final List<T> items;
  final Widget Function(BuildContext, T, int, Animation<double>) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return BaseAnimatedListView<T>(items: items, itemBuilder: itemBuilder);
  }
}
