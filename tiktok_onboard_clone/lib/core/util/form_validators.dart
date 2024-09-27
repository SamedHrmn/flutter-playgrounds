import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_onboard_clone/core/enum/localization_keys.dart';

String? validatePhoneNumber(String? phoneNumber, BuildContext context) {
  final numericRegex = RegExp(r'^[0-9]+$');

  if (phoneNumber == null || phoneNumber.isEmpty) {
    return LocalizationKeys.errorPhoneFieldEmpty.name.tr(context: context);
  }

  if ((phoneNumber.length < 7 || phoneNumber.length > 15) && numericRegex.hasMatch(phoneNumber)) {
    return LocalizationKeys.errorPhoneFieldInvalid.name.tr(context: context);
  }

  return null;
}

String? validateEmail(String? mail, BuildContext context) {
  if (mail == null || mail.isEmpty) return LocalizationKeys.errorEmailFieldEmpty.name.tr(context: context);
  const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
  final emailRegex = RegExp(pattern);

  if (!emailRegex.hasMatch(mail)) return LocalizationKeys.errorEmailFieldInvalid.name.tr(context: context);

  return null;
}
