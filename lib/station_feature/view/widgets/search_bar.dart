import 'package:flutter/material.dart';
import 'package:uot_transport/core/app_colors.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key, this.onSearch});

  final Function(String)? onSearch;

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'ابحث عن محطة',
                hintStyle: const TextStyle(color: AppColors.textColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: AppColors.primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide:
                      const BorderSide(color: AppColors.primaryColor, width: 2),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: AppColors.primaryColor),
                  onPressed: () {
                    if (onSearch != null) {
                      onSearch!(_controller.text);
                    }
                  },
                ),
              ),
              onSubmitted: (value) {
                if (onSearch != null) {
                  onSearch!(value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
