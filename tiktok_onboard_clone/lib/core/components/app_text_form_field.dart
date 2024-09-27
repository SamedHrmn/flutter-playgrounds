import 'package:flutter/material.dart';
import 'package:tiktok_onboard_clone/core/constant/color_constants.dart';
import 'package:tiktok_onboard_clone/core/util/app_sizer.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    this.controller,
    this.keyboardType,
    this.validator,
    this.prefixIcon,
    this.hintText,
    this.onChanged,
  });

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? prefixIcon;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    const border = UnderlineInputBorder(
      borderSide: BorderSide(color: ColorConstants.textSecondary),
    );

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        border: border,
        focusedBorder: border,
        enabledBorder: border,
        disabledBorder: border,
        contentPadding: AppSizer.padOnly(b: 16, t: 16),
        prefixIcon: prefixIcon,
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: ColorConstants.textSecondary,
              fontWeight: FontWeight.w400,
              fontSize: AppSizer.scaleWidth(16),
            ),
        hintText: hintText,
      ),
    );
  }
}
