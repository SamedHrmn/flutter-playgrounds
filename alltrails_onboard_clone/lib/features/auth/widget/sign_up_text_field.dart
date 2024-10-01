import 'package:alltrails_onboard_clone/core/components/app_text_form_field.dart';
import 'package:alltrails_onboard_clone/core/constants/asset_constants.dart';
import 'package:alltrails_onboard_clone/core/constants/color_constants.dart';
import 'package:alltrails_onboard_clone/core/util/app_sizer.dart';
import 'package:flutter/material.dart';

class SignUpTextField extends StatefulWidget {
  const SignUpTextField({
    super.key,
    required this.labelText,
    this.onChanged,
    this.validator,
    this.obscureText = false,
  });

  final String labelText;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool obscureText;

  @override
  State<SignUpTextField> createState() => _SignUpTextFieldState();
}

class _SignUpTextFieldState extends State<SignUpTextField> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void clearField() {
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: ColorConstants.primary2, width: 2),
    );

    return AppTextFormField(
      controller: controller,
      onChanged: widget.onChanged,
      validator: widget.validator,
      obscureText: widget.obscureText,
      border: border,
      style: TextStyle(
        fontFamily: AssetConstants.fontFamily,
        color: ColorConstants.textBlack,
        fontWeight: FontWeight.w500,
        fontSize: AppSizer.scaleWidth(16),
      ),
      floatingLabelStyle: TextStyle(
        fontFamily: AssetConstants.fontFamily,
        color: ColorConstants.primary2,
        fontWeight: FontWeight.w500,
        fontSize: AppSizer.scaleWidth(16),
      ),
      labelStyle: TextStyle(
        fontFamily: AssetConstants.fontFamily,
        color: ColorConstants.primary1.withOpacity(0.5),
        fontWeight: FontWeight.w400,
        fontSize: AppSizer.scaleWidth(16),
      ),
      labelText: widget.labelText,
      keyboardType: TextInputType.emailAddress,
      suffixIcon: IconButton.filled(
        onPressed: clearField,
        constraints: const BoxConstraints(),
        style: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(ColorConstants.secondary1),
        ),
        padding: AppSizer.allPadding(4),
        icon: Icon(
          Icons.close,
          size: AppSizer.scaleWidth(10),
          color: ColorConstants.background,
        ),
      ),
    );
  }
}
