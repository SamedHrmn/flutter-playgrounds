import 'dart:ui';

import 'package:donna_clone/app/components/text/base_text.dart';
import 'package:donna_clone/app/constant/asset_constants.dart';
import 'package:donna_clone/app/constant/color_constants.dart';
import 'package:donna_clone/app/enum/app_view_pages.dart';
import 'package:donna_clone/app/enum/localization_keys.dart';
import 'package:donna_clone/app/util/app_sizer.dart';
import 'package:donna_clone/features/home/managers/app_view_manager.dart';
import 'package:donna_clone/shared/widget/app_scaffold.dart';
import 'package:donna_clone/shared/widget/button/app_button.dart';
import 'package:donna_clone/shared/widget/empty_box.dart';
import 'package:donna_clone/shared/widget/text/app_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> with AppViewManager {
  @override
  Widget build(BuildContext context) {
    return AppViewInherited(
      activePage: activePage,
      pageController: pageController,
      child: AppScaffold(
        child: Stack(
          children: [
            backgroundGradient(),
            SafeArea(
              child: Column(
                children: [
                  _appBar(),
                  Expanded(
                    child: PageView.builder(
                      controller: pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: AppViewPages.values.length,
                      onPageChanged: updateNavBarPage,
                      itemBuilder: (context, index) {
                        return AppViewPages.values[index].toView();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: AppSizer.scaleHeight(AppSizer.bottomNavbarHeight),
              child: const AppBottomNavbar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return Padding(
      padding: AppSizer.verticallPadding(8) + AppSizer.pageHorizontalPadding,
      child: Row(
        children: [
          donnaText(),
          const Spacer(),
          const _HomeUserCard(),
          const EmptyBox(width: 16),
          hamburgerMenuButton(),
        ],
      ),
    );
  }

  AppText donnaText() {
    return const AppText(
      "Donna",
      fontFamily: AssetConstants.fontFamilyPrettyWise,
      fontSize: 28,
    );
  }

  AppButton hamburgerMenuButton() {
    return AppButton(
      isCircular: true,
      padding: AppSizer.allPadding(8),
      buttonColor: Colors.white.withOpacity(0.4),
      child: const Icon(
        Icons.menu_rounded,
        color: Colors.white,
      ),
    );
  }

  Widget backgroundGradient() {
    return Builder(builder: (context) {
      final activePage = AppViewInherited.of(context).activePage;
      List<Color> gColors = [];
      List<double> stops = const [0.1, 0.7];

      switch (activePage) {
        case AppViewPages.create:
          gColors = [
            ColorConstants.background1,
            ColorConstants.background2,
          ];

          break;
        case AppViewPages.explore:
          gColors = [
            ColorConstants.primary2,
            ColorConstants.background2,
          ];
        case AppViewPages.library:
          gColors = [
            ColorConstants.primary2,
            ColorConstants.background1,
          ];
          stops = [0, 1];
          break;
      }

      return Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.bottomLeft,
            radius: 1.5,
            colors: gColors,
            stops: stops,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(1, -0.5),
              radius: 0.7,
              colors: [
                Colors.white.withOpacity(0.4),
                Colors.transparent,
              ],
            ),
          ),
          child: activePage != AppViewPages.create
              ? Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(-1, 0.5),
                      radius: 0.7,
                      colors: [
                        Colors.white.withOpacity(0.4),
                        Colors.transparent,
                      ],
                    ),
                  ),
                )
              : null,
        ),
      );
    });
  }
}

class AppBottomNavbar extends StatelessWidget {
  const AppBottomNavbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent.withOpacity(0.5),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.5),
            width: 0.8,
          ),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Padding(
            padding: AppSizer.verticallPadding(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: AppViewPages.values
                  .map(
                    (page) => AppNavBarButton(page: page),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class AppNavBarButton extends StatefulWidget {
  const AppNavBarButton({super.key, required this.page});

  final AppViewPages page;

  @override
  State<AppNavBarButton> createState() => _AppNavBarButtonState();
}

class _AppNavBarButtonState extends State<AppNavBarButton> {
  @override
  Widget build(BuildContext context) {
    final appViewInherited = AppViewInherited.of(context);
    final isActivePage = appViewInherited.activePage == widget.page;

    return InkWell(
      onTap: () async {
        await AppViewInherited.of(context).toNavBarPage(widget.page);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.center,
            child: AnimatedScale(
              duration: Durations.short1,
              scale: isActivePage ? 1.2 : 1.0,
              child: Image.asset(
                widget.page.toIconPath(),
                height: AppSizer.scaleHeight(32),
                color: isActivePage ? widget.page.toIconActiveColor() : Colors.grey,
              ),
            ),
          ),
          const EmptyBox(height: 4),
          Flexible(
            child: AppText(
              widget.page.toNavbarText(context),
              fontSize: 14,
              color: isActivePage ? widget.page.toIconActiveColor() : Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}

class _HomeUserCard extends StatelessWidget {
  const _HomeUserCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSizer.allPadding(8) + AppSizer.horizontalPadding(2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: const Icon(Icons.person),
          ),
          const EmptyBox(width: 8),
          AppText(
            LocalizationKeys.pro.name.tr(context: context),
            appTextWeight: AppTextWeight.bold,
            fontSize: 20,
          ),
        ],
      ),
    );
  }
}
