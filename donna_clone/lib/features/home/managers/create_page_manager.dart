import 'package:flutter/material.dart';

mixin CreatePageManager on StatelessWidget {
  void updateHasExpand(bool value, ScrollController scrollController) {
    if (!scrollController.hasClients) return;

    if (value) {
      Future.delayed(Durations.medium1, () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Durations.medium3,
          curve: Curves.decelerate,
        );
      });
    }
  }
}

class CreatePageInterited extends InheritedWidget {
  const CreatePageInterited({
    super.key,
    required this.createWithDescriptionCardActiveTabIndex,
    required super.child,
  });

  final ValueNotifier<int> createWithDescriptionCardActiveTabIndex;

  void updateCreateCardTabIndex(int value) {
    createWithDescriptionCardActiveTabIndex.value = value;
  }

  static CreatePageInterited of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<CreatePageInterited>();
    if (result == null) {
      throw Exception("Can not find CreatePageInherited");
    }
    return result;
  }

  @override
  bool updateShouldNotify(CreatePageInterited oldWidget) {
    return true;
  }
}
