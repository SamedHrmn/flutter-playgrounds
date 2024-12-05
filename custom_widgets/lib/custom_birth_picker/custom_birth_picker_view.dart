import 'package:custom_widgets/custom_birth_picker/custom_birth_picker.dart';
import 'package:flutter/material.dart';

class CustomBirthPickerView extends StatelessWidget {
  const CustomBirthPickerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(
              flex: 5,
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: FittedBox(
                  child: Text(
                    'ListWheelScroll Date Picker',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 24),
                  ),
                ),
              ),
            ),
            const Expanded(
              flex: 20,
              child: FractionallySizedBox(
                heightFactor: 0.5,
                child: CustomBirthPicker(),
              ),
            ),
            const Spacer(
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}
