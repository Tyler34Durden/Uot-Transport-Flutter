import 'package:flutter/material.dart';
import 'package:uot_transport/core/app_colors.dart';

class BackHeader extends StatelessWidget implements PreferredSizeWidget {
  const BackHeader({this.showBackBtn = true, super.key, this.onBackbtn});

  final bool showBackBtn;
  final Function()? onBackbtn;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AppBar(
        leading: showBackBtn
            ? IconButton(
                icon: const Icon(
                  Icons.chevron_left_rounded,
                  color: AppColors.primaryColor,
                  size: 30,
                ),
                onPressed: onBackbtn ?? () => Navigator.pop(context),
              )
            : null,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
