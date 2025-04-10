import 'package:flutter/material.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_dropdown.dart';


class TripSelectionWidget extends StatefulWidget {
  const TripSelectionWidget({super.key});

  @override
  _TripSelectionWidgetState createState() => _TripSelectionWidgetState();
}

class _TripSelectionWidgetState extends State<TripSelectionWidget> {
  String? selectedValue1;
  String? selectedValue2;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            AppDropdown(
              items: const ['Option 1', 'Option 2', 'Option 3'],
              hintText: 'من',
              value: selectedValue1,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValue1 = newValue;
                });
              },
            ),
            const SizedBox(height: 20),
            AppDropdown(
              items: const ['Option 1', 'Option 2', 'Option 3'],
              hintText: 'الى',
              value: selectedValue2,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValue2 = newValue;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}