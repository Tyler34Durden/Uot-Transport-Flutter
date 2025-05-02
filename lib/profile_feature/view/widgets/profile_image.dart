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
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        children: [
          Positioned.fill(
            child: CircleAvatar(
              backgroundColor: AppColors.primaryColor,
              child: imageUrl.isEmpty
                  ? SvgPicture.asset(
                AppIcons.user,
                width: 60,
                height: 60,
              )
                  : null,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onEdit,
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.edit,
                  size: 18,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}