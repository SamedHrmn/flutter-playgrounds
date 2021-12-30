import 'package:flutter/material.dart';

class CustomAnimatedContainer extends StatelessWidget {
  const CustomAnimatedContainer({Key? key, required this.isSelected}) : super(key: key);

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
              offset: Offset(0, 20),
              blurRadius: 40,
              color: Colors.black.withOpacity(0.05),
            )
          ]),
      width: double.maxFinite,
      duration: Duration(milliseconds: 400),
      child: Center(
        child: isSelected
            ? Text(
                "Clicked !",
                style: TextStyle(fontSize: 18),
              )
            : Text(
                "Click Me!",
                style: TextStyle(fontSize: 16),
              ),
      ),
    );
  }
}
