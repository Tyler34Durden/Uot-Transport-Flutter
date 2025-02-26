
import 'package:flutter/material.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport/core/app_colors.dart';

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    this.gradient,
    this.style,
    this.onTap, required TextDirection textDirection,
  });

  final String text;
  final TextStyle? style;
  final Gradient? gradient;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ShaderMask(
        blendMode: BlendMode.srcIn,
        // shaderCallback: (bounds) => gradient.createShader(
        //   Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        // ),
        shaderCallback: (bounds) {
          return const LinearGradient(colors: [
            AppColors.primaryColor,
            AppColors.primaryColor,
          ]).createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          );
        },
        child: AppText(
          lbl: text,
          style: style,
        ),
      ),
    );
  }
}
