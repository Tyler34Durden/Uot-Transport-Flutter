//added after removed
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/app_icons.dart';

class ProfileImageWidget extends StatelessWidget {
  final String imageUrl;
  final VoidCallback? onEdit;

  const ProfileImageWidget({
    Key? key,
    required this.imageUrl,
    this.onEdit,
  }) : super(key: key);

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
          // Positioned(
          //   bottom: 0,
          //   right: 0,
          //   child: GestureDetector(
          //     onTap: onEdit,
          //     child: Container(
          //       width: 35,
          //       height: 35,
          //       decoration: BoxDecoration(
          //         shape: BoxShape.circle,
          //         color: Colors.white,
          //         border: Border.all(
          //           color: Colors.white,
          //           width: 2,
          //         ),
          //       ),
          //       child: const Icon(
          //         Icons.edit,
          //         size: 18,
          //         color: AppColors.primaryColor,
          //       ),
          //     ),
          //   ),
          // ),
      ),
  ]
    ),
    );
  }
}