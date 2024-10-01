import 'package:alltrails_onboard_clone/core/constants/color_constants.dart';
import 'package:alltrails_onboard_clone/core/util/app_sizer.dart';
import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    this.controller,
    this.style,
    this.floatingLabelStyle,
    this.labelStyle,
    this.keyboardType,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.border,
    this.obscureText = false,
    this.labelText,
    this.onChanged,
  });

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final String? labelText;
  final TextStyle? style;
  final TextStyle? labelStyle;
  final TextStyle? floatingLabelStyle;
  final InputBorder? border;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    final _border = border ??
        const OutlineInputBorder(
          borderSide: BorderSide(color: ColorConstants.primary2),
        );

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      obscureText: obscureText,
      style: style ?? Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        border: _border,
        focusedBorder: _border,
        enabledBorder: _border,
        disabledBorder: _border,
        contentPadding: AppSizer.padOnly(b: 16, t: 16, l: 12, r: 12),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        prefixIconConstraints: const BoxConstraints(),
        suffixIconConstraints: const BoxConstraints(),
        floatingLabelStyle: floatingLabelStyle,
        labelText: labelText,
        labelStyle: labelStyle,
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: ColorConstants.primary1.withOpacity(0.5),
              fontWeight: FontWeight.w400,
              fontSize: AppSizer.scaleWidth(16),
            ),
        hintText: hintText,
      ),
    );
  }
}
