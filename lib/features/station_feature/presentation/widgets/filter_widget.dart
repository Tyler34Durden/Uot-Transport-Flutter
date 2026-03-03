import 'package:flutter/material.dart';
import 'package:uot_transport/core/app_icons.dart';

class FilterWidget extends StatelessWidget {
  const FilterWidget({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
    this.fontSize,
  });

  final String selectedFilter;
  final void Function(String) onFilterSelected;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Image.asset(AppIcons.filterIcon),
      onSelected: onFilterSelected,
      itemBuilder: (BuildContext context) => const [
        PopupMenuItem(
          value: 'داخل الجامعة',
          child: Text('داخل الجامعة', textAlign: TextAlign.right),
        ),
        PopupMenuItem(
          value: 'خارج الجامعة',
          child: Text('خارج الجامعة', textAlign: TextAlign.right),
        ),
      ],
    );
  }
}
