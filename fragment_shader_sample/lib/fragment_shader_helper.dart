import 'dart:ui' as ui;

enum BurningShaderUniforms {
  sourceTexture(0),
  targetTexture(1),
  iTime(2),
  iResolutionWidth(0),
  iResoultionHeight(1);

  const BurningShaderUniforms(this.uniformIndex);

  final int uniformIndex;
}

final class FragmentShaderHelper {
  late final ui.FragmentShader _fragmentShader;
  bool isShaderReady = false;

  static const String assetPath = 'assets/shaders/burn.frag';

  static final FragmentShaderHelper _instance = FragmentShaderHelper._init();

  factory FragmentShaderHelper.instance() => _instance;

  FragmentShaderHelper._init();

  Future<void> initShader() async {
    _fragmentShader = await _loadShaderFromAsset();
    isShaderReady = true;
  }

  void _notInitializedException() {
    if (!isShaderReady) {
      throw Exception('fragmentShader does not initialized, call initShader before.');
    }
  }

  ui.FragmentShader getShader() {
    _notInitializedException();
    return _fragmentShader;
  }

  void setTextureSampler(ui.Image textureImage, BurningShaderUniforms uniform) {
    _notInitializedException();
    _fragmentShader.setImageSampler(uniform.uniformIndex, textureImage);
  }

  void setCanvasSize({required int width, required int height}) {
    _notInitializedException();

    _fragmentShader.setFloat(BurningShaderUniforms.iResolutionWidth.uniformIndex, width.toDouble());
    _fragmentShader.setFloat(BurningShaderUniforms.iResoultionHeight.uniformIndex, height.toDouble());
  }

  void setTimer(double elapsedTime) {
    _notInitializedException();
    _fragmentShader.setFloat(BurningShaderUniforms.iTime.uniformIndex, elapsedTime);
  }

  Future<ui.FragmentShader> _loadShaderFromAsset() async {
    final program = await ui.FragmentProgram.fromAsset(assetPath);
    return program.fragmentShader();
  }

  void dispose() {
    _fragmentShader.dispose();
  }
}
