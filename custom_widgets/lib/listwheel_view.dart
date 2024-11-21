import 'package:custom_widgets/widget/custom_birth_picker.dart';
import 'package:flutter/material.dart';

class ListWheelView extends StatelessWidget {
  const ListWheelView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ListWheelScroll'),
        leading: IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back)),
      ),
      body: Column(
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
    );
  }
}
