import 'package:donna_clone/app/constant/asset_constants.dart';
import 'package:donna_clone/app/constant/color_constants.dart';
import 'package:donna_clone/app/enum/localization_keys.dart';
import 'package:donna_clone/features/home/pages/create_page.dart';
import 'package:donna_clone/features/home/pages/explore_page.dart';
import 'package:donna_clone/features/home/pages/library_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum AppViewPages {
  create,
  explore,
  library;

  Widget toView() {
    switch (this) {
      case AppViewPages.create:
        return const CreatePage();
      case AppViewPages.explore:
        return const ExplorePage();
      case AppViewPages.library:
        return const LibraryPage();
    }
  }

  String toNavbarText(BuildContext context) {
    switch (this) {
      case AppViewPages.create:
        return LocalizationKeys.navbarCreate.name.tr(context: context);
      case AppViewPages.explore:
        return LocalizationKeys.navbarExplore.name.tr(context: context);

      case AppViewPages.library:
        return LocalizationKeys.navbarLibrary.name.tr(context: context);
    }
  }

  String toIconPath() {
    switch (this) {
      case AppViewPages.create:
        return AssetConstants.icNavbarCreate;
      case AppViewPages.explore:
        return AssetConstants.icNavbarExplore;
      case AppViewPages.library:
        return AssetConstants.icNavbarLibrary;
    }
  }

  Color toIconActiveColor() {
    switch (this) {
      case AppViewPages.create:
        return ColorConstants.primary1;
      case AppViewPages.explore:
        return ColorConstants.primary1;
      case AppViewPages.library:
        return ColorConstants.primary2;
    }
  }
}
