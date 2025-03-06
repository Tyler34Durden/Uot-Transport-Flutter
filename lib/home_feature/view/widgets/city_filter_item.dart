import 'package:flutter/material.dart';
import 'package:uot_transport/core/app_colors.dart';

class CityFilterItem extends StatelessWidget {
  final String title;
  final bool isSelected;

  const CityFilterItem({
    Key? key,
    required this.title,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 45.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryColor : AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isSelected ? AppColors.primaryColor : AppColors.secondaryColor,
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}