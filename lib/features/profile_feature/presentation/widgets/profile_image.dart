import 'package:flutter/material.dart';

import 'package:uot_transport/core/app_colors.dart';

class ProfileImageWidget extends StatelessWidget {
  const ProfileImageWidget({
    super.key,
    required this.imageUrl,
    this.onEdit,
  });

  final String imageUrl;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width * 0.3;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Positioned.fill(
            child: CircleAvatar(
              backgroundColor: AppColors.primaryColor,
              backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
              child: imageUrl.isEmpty
                  ? Icon(Icons.person, size: size * 0.5, color: Colors.white)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

