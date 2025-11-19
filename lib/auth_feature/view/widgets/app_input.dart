import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uot_transport/core/app_colors.dart';

class AppInput extends StatelessWidget {
  const AppInput({
    Key? key,
    this.hintText,
    this.br,
    this.style,
    this.border,
    this.fillColor,
    this.prefixIcon,
    this.hintStyle,
    this.suffixIcon,
    this.obscureText = false,
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
    this.inputFormatters,
    this.readOnly = false,
    this.onSuffixIconTap,
  }) : super(key: key);

  final double? br;
  final String? hintText;
  final Color? fillColor;
  final bool obscureText;
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
  final List<TextInputFormatter>? inputFormatters;
  final Locale? locale;
  final int? maxLength;
  final bool readOnly;
  final VoidCallback? onSuffixIconTap;

  @override
  Widget build(BuildContext context) {
    // Wrap the suffix icon with gesture detector if a tap handler is provided
    Widget? wrappedSuffix = suffixIcon;
    if (suffixIcon != null && onSuffixIconTap != null) {
      wrappedSuffix = GestureDetector(onTap: onSuffixIconTap, child: suffixIcon);
    }

    final baseDecoration = decoration ?? InputDecoration();

    final effectiveDecoration = baseDecoration.copyWith(
      hintText: hintText,
      fillColor: fillColor ?? Colors.white,
      filled: true,
      hintStyle: hintStyle ?? TextStyle(color: Colors.grey[400], fontSize: 15),
      enabledBorder: enabledBorder ?? OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primaryColor, width: .5),
        borderRadius: BorderRadius.circular(br ?? 15),
      ),
      focusedBorder: focusedBorder ?? OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 1),
        borderRadius: BorderRadius.circular(br ?? 15),
      ),
      border: border ?? OutlineInputBorder(borderRadius: BorderRadius.circular(br ?? 15)),
      prefixIcon: prefixIcon,
      suffixIcon: wrappedSuffix,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );

    return TextFormField(
      controller: controller,
      decoration: effectiveDecoration,
      autofocus: false,
      autocorrect: false,
      obscureText: obscureText,
      onChanged: onChanged,
      style: style ?? const TextStyle(color: Colors.black, fontSize: 14),
      textAlign: textAlign ?? TextAlign.right,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      readOnly: readOnly,
      maxLength: maxLength,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      buildCounter: (BuildContext context, {int? currentLength, bool? isFocused, int? maxLength}) => null,
    );
  }
}