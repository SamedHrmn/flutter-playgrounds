import 'package:flutter/material.dart';

class CustomAnimatedContainer extends StatelessWidget {
  const CustomAnimatedContainer({required this.isSelected, super.key});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        gradient: isSelected ? LinearGradient(colors: [Colors.blue, Colors.blueAccent.shade100]) : null,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 20),
            blurRadius: 40,
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      width: double.maxFinite,
      duration: const Duration(milliseconds: 400),
      child: Center(
        child: isSelected
            ? const Text(
                'Clicked !',
                style: TextStyle(fontSize: 18),
              )
            : const Text(
                'Click Me!',
                style: TextStyle(fontSize: 16),
              ),
      ),
    );
  }
}
