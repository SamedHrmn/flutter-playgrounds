enum EffectTypes {
  noiseReduction("Noise Reduction"),
  echoDelay("Echo Delay"),
  echoDecay("Echo Decay"),
  bassGain("Bass Gain"),
  trebleGain("Treble Gain"),
  volume("Volume"),
  reverb("Reverb"),
  compressorThreshold("Compressor Threshold"),
  compressorRatio("Compressor Ratio"),
  chorusInGain("Chorus In Gain"),
  chorusOutGain("Chorus Out Gain"),
  stereoWiden("Stereo Widen"),
  equalizerGain("Equalizer Gain");

  final String name;

  const EffectTypes(this.name);
}
