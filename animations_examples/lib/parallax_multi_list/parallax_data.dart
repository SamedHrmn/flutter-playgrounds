import 'package:animations_examples/constants/asset_constants.dart';

class ParallaxData {
  final String imagePath;
  final List<String> subImages;

  static const parallaxImages = [
    AssetConstants.imNature1,
    AssetConstants.imNature2,
    AssetConstants.imNature3,
    AssetConstants.imNature4,
    AssetConstants.imNature5,
    AssetConstants.imNature6,
    AssetConstants.imNature7,
  ];

  ParallaxData({
    required this.imagePath,
    required this.subImages,
  });

  static List<ParallaxData> initializeParallaxListWheelList() {
    final parallaxItems = <ParallaxData>[];

    for (final element in parallaxImages) {
      final restOfImages = parallaxImages.where((innerImage) => innerImage != element).toList();

      final model = ParallaxData(
        imagePath: element,
        subImages: restOfImages,
      );

      parallaxItems.add(model);
    }

    return parallaxItems;
  }
}
