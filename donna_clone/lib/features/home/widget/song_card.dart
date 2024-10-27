import 'package:donna_clone/app/components/text/base_text.dart';
import 'package:donna_clone/app/constant/color_constants.dart';
import 'package:donna_clone/app/extension/number_extension.dart';
import 'package:donna_clone/app/util/app_sizer.dart';
import 'package:donna_clone/features/home/data/song_model.dart';
import 'package:donna_clone/shared/widget/app_asset_image.dart';
import 'package:donna_clone/shared/widget/empty_box.dart';
import 'package:donna_clone/shared/widget/text/app_text.dart';
import 'package:flutter/material.dart';

class SongCard extends StatelessWidget {
  const SongCard({
    super.key,
    required this.item,
    required this.index,
  });

  final SongModel item;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -AppSizer.scaleHeight(18),
          right: 0,
          child: index <= 2
              ? Container(
                  padding: AppSizer.padOnly(l: 8, r: 8, b: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [
                        ColorConstants.primary1,
                        ColorConstants.primary2,
                      ],
                    ),
                  ),
                  child: AppText(
                    "#${index + 1}",
                    fontSize: 15,
                  ),
                )
              : const SizedBox(),
        ),
        Container(
          padding: AppSizer.allPadding(8),
          decoration: BoxDecoration(
            borderRadius: AppSizer.borderRadius,
            color: ColorConstants.background3,
          ),
          child: Row(
            children: [
              AppAssetImage(path: item.imageUrl),
              const EmptyBox(width: 12),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      item.title ?? "-",
                      fontSize: 20,
                      isOverflow: true,
                    ),
                    const EmptyBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _numInfoContainer(
                          icon: Icons.play_arrow_rounded,
                          icPad: AppSizer.padOnly(b: 2),
                          size: 17,
                          text: item.count.toShortenedFormat(),
                        ),
                        const EmptyBox(width: 8),
                        _numInfoContainer(
                          icon: Icons.favorite_rounded,
                          size: 13,
                          icPad: AppSizer.padOnly(t: 2),
                          text: item.likes.toShortenedFormat(),
                        ),
                        const EmptyBox(width: 4),
                        Flexible(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.person_rounded,
                                color: ColorConstants.primary2,
                                size: AppSizer.scaleWidth(15),
                              ),
                              Flexible(
                                child: AppText(
                                  item.author ?? "-",
                                  color: ColorConstants.primary2,
                                  fontSize: 14,
                                  isOverflow: true,
                                  appTextWeight: AppTextWeight.regular,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container _numInfoContainer({
    required IconData icon,
    required String text,
    EdgeInsetsGeometry? icPad,
    required double size,
  }) {
    return Container(
      padding: AppSizer.padOnly(l: 6, r: 8, b: 2, t: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: AppSizer.borderRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: icPad ?? EdgeInsets.zero,
            child: Icon(
              icon,
              color: Colors.white,
              size: AppSizer.scaleWidth(size),
            ),
          ),
          const EmptyBox(width: 2),
          AppText(
            text,
            fontSize: 14,
          ),
        ],
      ),
    );
  }
}
