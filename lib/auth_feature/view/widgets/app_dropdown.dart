import 'package:flutter/material.dart';
import 'package:uot_transport/core/app_colors.dart';

class AppDropdown extends StatelessWidget {
  const AppDropdown({
    required this.items,
    required this.hintText,
    this.onChanged,
    this.value,
    super.key,
  });

  final List<String> items;
  final String hintText;
  final String? value;
  final Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DropdownButtonFormField<String>(
        
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.textColor, fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: AppColors.primaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: AppColors.primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
          ),
        ),
        value: value,
        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primaryColor),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  item,
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: AppColors.textColor, fontSize: 14),
                ),
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        dropdownColor: AppColors.backgroundColor,
        style: const TextStyle(color: AppColors.textColor, fontSize: 14),
      ),
    );
  }
}