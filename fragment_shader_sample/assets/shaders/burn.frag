#include <flutter/runtime_effect.glsl>
// Original Source: https://www.shadertoy.com/view/ltV3RG

#define ANIM_DURATION 2.5

uniform vec2 uSize;
vec2 iResolution;
uniform float iTime;
uniform float iFrame;
uniform vec4 iMouse;
uniform sampler2D sourceImage;
uniform sampler2D targetImage;

out vec4 fragColor;

// Check if the texture is empty by inspecting its alpha channel and RGB values
bool isTextureEmpty(sampler2D tex, vec2 uv) {
    vec4 txt = texture(tex, uv);
    return txt.a == 0.0 && txt.rgb == vec3(0.0);
}

// Sample the source texture, returning a vec4 instead of vec3 for consistency
vec4 textureSource(sampler2D textureSampler, vec2 uv) {
    return texture(textureSampler, uv);
}

// Noise and fbm functions remain unchanged
float Hash(vec2 p) {
    vec3 p2 = vec3(p.xy, 1.0);
    return fract(sin(dot(p2, vec3(37.1, 61.7, 12.4))) * 3758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * (3.0 - 2.0 * f);
    return mix(
        mix(Hash(i + vec2(0.0, 0.0)), Hash(i + vec2(1.0, 0.0)), f.x),
        mix(Hash(i + vec2(0.0, 1.0)), Hash(i + vec2(1.0, 1.0)), f.x),
        f.y
    );
}

float fbm(vec2 p) {
    float v = 0.0;
    v += noise(p * 1.0) * 0.5;
    v += noise(p * 2.0) * 0.25;
    v += noise(p * 4.0) * 0.125;
    return v;
}

void main(void) {
    iResolution = uSize;
    vec2 fragCoord = FlutterFragCoord();
    vec2 uv = fragCoord / iResolution.xy;

    // Use vec4 for source and target
    vec4 src = textureSource(sourceImage, uv);
    vec4 tgt = vec4(0.0); // Default to transparent if the target texture is empty

    // Check if the target texture is not empty
    if (!isTextureEmpty(targetImage, uv)) {
        tgt = texture(targetImage, uv);
    }

    vec3 col = src.rgb; // Start with source RGB

    uv.x -= 1.5;

    float ctime = mod(iTime * 0.5, ANIM_DURATION);

    // Burn effect
    float d = uv.x + uv.y * 0.5 + 0.5 * fbm(uv * 15.1) + ctime * 1.3;
    if (d > 0.35) col = clamp(col - (d - 0.35) * 10.0, 0.0, 1.0);
    if (d > 0.47) {
        if (d < 0.5) {
            col += (d - 0.4) * 33.0 * 0.5 * (0.0 + noise(100.0 * uv + vec2(-ctime * 2.0, 0.0))) * vec3(1.5, 0.5, 0.0);
        } else {
            col += tgt.rgb; // Use RGB from the target texture
        }
    }

    fragColor = vec4(col, 1.0); // Output as vec4 with full alpha
}
