import 'package:animations_examples/custom_animated_container/custom_animated_container.dart';
import 'package:flutter/material.dart';

class AnimatedContainersView extends StatefulWidget {
  const AnimatedContainersView({super.key});

  @override
  _AnimatedContainersViewState createState() => _AnimatedContainersViewState();
}

class _AnimatedContainersViewState extends State<AnimatedContainersView> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            selectableAnimatedContainer(position: 0),
            selectableAnimatedContainer(position: 1),
            selectableAnimatedContainer(position: 2),
            selectableAnimatedContainer(position: 3),
          ],
        ),
      ),
    );
  }

  Widget selectableAnimatedContainer({required int position}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = position;
        });
      },
      child: CustomAnimatedContainer(
        isSelected: selectedIndex == position,
      ),
    );
  }
}
