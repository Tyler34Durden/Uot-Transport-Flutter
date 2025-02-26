import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  const AppText({
    required this.lbl,
    this.style,
    this.overflow,
    this.maxLines,
    this.textAlign,
    this.onTap,
    super.key,
  });

  final String? lbl;
  final int? maxLines;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        lbl ?? '',
        style: style,
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign,
      ),
    );
  }
}