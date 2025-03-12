import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uot_transport/core/app_colors.dart';

class AppInput extends StatelessWidget {
  const AppInput({
    this.hintText,
    this.br,
    this.style,
    this.border,
    this.fillColor,
    this.prefixIcon,
    this.hintStyle,
    this.suffixIcon,
    this.obscureText,
    this.enabledBorder,
    this.focusedBorder,
    this.onChanged,
    this.controller,
    this.textAlign,
    this.validator,
    this.keyboardType,
    this.decoration,
    this.locale,
    this.maxLength,
    super.key,
  });

  final double? br;
  final String? hintText;
  final Color? fillColor;
  final bool? obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final InputBorder? border;
  final TextStyle? hintStyle;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final TextStyle? style;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final TextAlign? textAlign;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final InputDecoration? decoration;
  final Locale? locale;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: decoration?.copyWith(
            hintText: hintText,
            fillColor: fillColor ?? Colors.white,
            hintStyle:
                hintStyle ?? TextStyle(color: Colors.grey[400], fontSize: 15),
            enabledBorder: enabledBorder ??
                OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: AppColors.primaryColor, width: .5),
                  borderRadius: BorderRadius.circular(br ?? 15),
                ),
            focusedBorder: focusedBorder ??
                OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: AppColors.secondaryColor, width: 1),
                  borderRadius: BorderRadius.circular(br ?? 15),
                ),
            border: border ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(br ?? 15),
                ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ) ??
          InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            hintText: hintText,
            fillColor: fillColor ?? Colors.white,
            hintStyle:
                hintStyle ?? TextStyle(color: Colors.grey[400], fontSize: 15),
            enabledBorder: enabledBorder ??
                OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: AppColors.primaryColor, width: .5),
                  borderRadius: BorderRadius.circular(br ?? 15),
                ),
            focusedBorder: focusedBorder ??
                OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColors.primaryColor, width: 1),
                  borderRadius: BorderRadius.circular(br ?? 15),
                ),
            border: border ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(br ?? 15),
                ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
      autofocus: false,
      autocorrect: false,
      obscureText: obscureText ?? false,
      onChanged: onChanged,
      style: style ?? const TextStyle(color: Colors.black, fontSize: 14),
      textAlign: textAlign ?? TextAlign.right,
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLength: maxLength,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      buildCounter: (BuildContext context,
              {int? currentLength, bool? isFocused, int? maxLength}) =>
          null,
    );
  }
}
