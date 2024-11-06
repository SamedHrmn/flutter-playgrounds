import 'package:flutter/material.dart';
import 'package:srgan_client/constants/size_constants.dart';
import 'package:srgan_client/widgets/app_memory_image.dart';
import 'package:srgan_client/widgets/app_shimmer.dart';
import 'package:srgan_client/widgets/app_text.dart';

import 'constants/string_constants.dart';
import 'image_select_view_mixin.dart';

class ImageSelectView extends StatefulWidget {
  const ImageSelectView({super.key});

  @override
  State<ImageSelectView> createState() => _ImageSelectViewState();
}

class _ImageSelectViewState extends State<ImageSelectView> with ImageSelectViewMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const AppText(text: StringConstants.appBarText)),
      body: SafeArea(
        child: Padding(
          padding: SizeConstants.pageOuterPadding(),
          child: Column(
            children: [
              Expanded(
                child: galleryImageBuilder(),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: outputImageBuilder(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Center outputImageBuilder() {
    return Center(
      child: ValueListenableBuilder(
        valueListenable: upscaledImageState,
        builder: (context, state, _) {
          Widget widget;

          if (state.status == UpscaledImageFetchStatus.initial) {
            widget = const SizedBox.shrink();
          } else if (state.status == UpscaledImageFetchStatus.error) {
            widget = const AppText(
              text: StringConstants.networkFetchErrorText,
            );
          } else if (state.status == UpscaledImageFetchStatus.loading) {
            widget = const _ImageLoaderShimmer();
          } else {
            widget = AppMemoryImage(base64Str: state.outputImage!);
          }

          return AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            child: widget,
          );
        },
      ),
    );
  }

  Widget galleryImageBuilder() {
    return ValueListenableBuilder(
      valueListenable: upscaledImageState,
      builder: (context, state, _) {
        if (state.status == UpscaledImageFetchStatus.initial || state.status == UpscaledImageFetchStatus.error) {
          return GestureDetector(
            onTap: pickGalleryImageAsBase64,
            child: Container(
              height: double.maxFinite,
              width: double.maxFinite,
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: SizeConstants.borderRadiusGeneral(),
                color: Colors.white,
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.photo_camera),
                  AppText(text: StringConstants.pickAnImage),
                ],
              ),
            ),
          );
        }

        return GestureDetector(
          onTap: pickGalleryImageAsBase64,
          child: AppMemoryImage(base64Str: state.galleryImage!),
        );
      },
    );
  }
}

class _ImageLoaderShimmer extends StatelessWidget {
  const _ImageLoaderShimmer();

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ClipRRect(
        borderRadius: SizeConstants.borderRadiusGeneral(),
        child: const SizedBox.expand(
          child: ColoredBox(color: Colors.grey),
        ),
      ),
    );
  }
}
