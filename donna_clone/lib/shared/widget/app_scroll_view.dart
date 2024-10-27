import 'package:flutter/material.dart';

class AppScrollView extends StatefulWidget {
  const AppScrollView({super.key, required this.builder});
  final Widget Function(ScrollController scrollController) builder;

  @override
  State<AppScrollView> createState() => _AppScrollViewState();
}

class _AppScrollViewState extends State<AppScrollView> {
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: widget.builder(scrollController),
    );
  }
}
