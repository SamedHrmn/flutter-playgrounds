class ResultBundle {
  final List<HandLandmarkerResult> results;
  final int inferenceTime;
  final int inputImageHeight;
  final int inputImageWidth;

  ResultBundle({
    required this.results,
    required this.inferenceTime,
    required this.inputImageHeight,
    required this.inputImageWidth,
  });

  factory ResultBundle.fromMap(Map<String, dynamic> map) {
    return ResultBundle(
      results: List<HandLandmarkerResult>.from(
        (map['results'] as List<dynamic>).map(
          (item) => HandLandmarkerResult.fromMap(item),
        ),
      ),
      inferenceTime: map['inferenceTime'] as int,
      inputImageHeight: map['inputImageHeight'] as int,
      inputImageWidth: map['inputImageWidth'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'results': results.map((result) => result.toMap()).toList(),
      'inferenceTime': inferenceTime,
      'inputImageHeight': inputImageHeight,
      'inputImageWidth': inputImageWidth,
    };
  }
}

class HandLandmarkerResult {
  final List<Landmark> landmarks;

  HandLandmarkerResult({
    required this.landmarks,
  });

  factory HandLandmarkerResult.fromMap(Map<Object?, Object?> map) {
    return HandLandmarkerResult(
      landmarks: (map['landmarks'] as List<dynamic>)
          .map(
            (item) => Landmark.fromMap(item),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'landmarks': landmarks.map((landmark) => landmark.toMap()).toList(),
    };
  }
}

class Landmark {
  final double x;
  final double y;
  final double z;

  Landmark({
    required this.x,
    required this.y,
    required this.z,
  });

  factory Landmark.fromMap(Map<Object?, Object?> map) {
    return Landmark(
      x: (map['x'] as num).toDouble(),
      y: (map['y'] as num).toDouble(),
      z: (map['z'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'x': x,
      'y': y,
      'z': z,
    };
  }
}
