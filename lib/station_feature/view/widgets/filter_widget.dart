import 'package:flutter/material.dart';
import 'package:uot_transport/core/app_icons.dart';

class FilterWidget extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterSelected;

  const FilterWidget({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Image.asset(AppIcons.filterIcon),
      onSelected: (String value) {
        onFilterSelected(value);
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem(
          value: 'الكل',
          child: Text(
            'الكل',
            textAlign: TextAlign.right,
          ),
        ),
        const PopupMenuItem(
          value: 'داخل الجامعة',
          child: Text(
            'داخل الجامعة',
            textAlign: TextAlign.right,
          ),
        ),
        const PopupMenuItem(
          value: 'خارج الجامعة',
          child: Text(
            'خارج الجامعة',
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}