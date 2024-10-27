import 'package:donna_clone/app/constant/color_constants.dart';
import 'package:donna_clone/app/enum/localization_keys.dart';
import 'package:donna_clone/app/util/app_sizer.dart';
import 'package:donna_clone/features/home/widget/select_genre_bottom_sheet.dart';
import 'package:donna_clone/shared/widget/button/app_inkwell_button.dart';
import 'package:donna_clone/shared/widget/empty_box.dart';
import 'package:donna_clone/shared/widget/text/app_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SelectGenreList extends StatefulWidget {
  const SelectGenreList({super.key});

  @override
  State<SelectGenreList> createState() => _SelectGenreListState();
}

class _SelectGenreListState extends State<SelectGenreList> {
  final genres = List<LocalizationKeys>.from(LocalizationKeys.values.where(
    (value) => value.name.contains("genre."),
  ));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: AppSizer.pageHorizontalPadding,
          child: Row(
            children: [
              AppText(
                LocalizationKeys.selectGenre.name.tr(context: context),
              ),
              AppText(
                " (${LocalizationKeys.optional.name.tr(context: context)})",
              ),
            ],
          ),
        ),
        SizedBox(
          height: AppSizer.scaleHeight(190),
          child: _genreListView(),
        ),
      ],
    );
  }

  ListView _genreListView() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: AppSizer.allPadding(16),
      separatorBuilder: (context, index) => const EmptyBox(width: 8),
      itemBuilder: (context, index) {
        if (genres[index].name == 'genre.more') {
          return _GenreCard(
            text: genres[index].name.tr(context: context),
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: ColorConstants.background1,
                builder: (context) {
                  return const SelectGenreBottomSheet();
                },
              );
            },
            child: ColoredBox(
              color: Colors.white.withOpacity(0.5),
              child: Icon(
                Icons.more_horiz_rounded,
                size: AppSizer.scaleWidth(50),
              ),
            ),
          );
        }

        return _GenreCard(
          text: genres[index].name.tr(context: context),
          assetPath: genres[index].assetPath!,
          onTap: () {},
        );
      },
      itemCount: genres.length,
    );
  }
}

class _GenreCard extends StatelessWidget {
  const _GenreCard({
    required this.text,
    this.assetPath,
    required this.onTap,
    this.child,
  });

  final String text;
  final String? assetPath;
  final Widget? child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizer.scaleWidth(90),
      child: Column(
        children: [
          AppInkwellButton(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            color: Colors.transparent,
            child: SizedBox(
              width: double.maxFinite,
              height: AppSizer.scaleHeight(100),
              child: ClipRRect(
                borderRadius: AppSizer.borderRadius,
                child: child ??
                    Image.asset(
                      assetPath!,
                      fit: BoxFit.cover,
                    ),
              ),
            ),
          ),
          const EmptyBox(height: 8),
          Expanded(
            child: Padding(
              padding: AppSizer.horizontalPadding(8),
              child: AppText(
                text,
                maxLines: 2,
              ),
            ),
          )
        ],
      ),
    );
  }
}
