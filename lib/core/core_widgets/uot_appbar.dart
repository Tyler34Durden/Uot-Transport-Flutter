import 'package:flutter/material.dart';
          import 'package:flutter_svg/flutter_svg.dart';
          import 'package:uot_transport/core/app_colors.dart';
          import 'package:uot_transport/core/app_icons.dart';

          class UotAppbar extends StatelessWidget implements PreferredSizeWidget {
            const UotAppbar({super.key});

            @override
            Widget build(BuildContext context) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: AppBar(
                  leading: Padding(
                    padding: const EdgeInsets.only(right: 10), // Adjust the padding value as needed
                    child: Image.asset(AppIcons.logoPath, width: 80, height: 80),
                  ),
                  backgroundColor: AppColors.backgroundColor,
                  elevation: 0,
                  actions: [
                    IconButton(
                      icon: SvgPicture.asset(AppIcons.outline_NotificationsAppPath, width: 20, height: 22, color: AppColors.primaryColor),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: SvgPicture.asset(AppIcons.outline_SearchAppPath, width: 24, height: 24, color: AppColors.primaryColor),
                      onPressed: () {},
                    ),
                  ],
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(1.0),
                    child: Container(
                      color: Color(0xffCED2D8),
                      height: 1.0,
                    ),
                  ),
                ),
              );
            }

            @override
            Size get preferredSize => const Size.fromHeight(56);
          }