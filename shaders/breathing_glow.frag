#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uBreath; // 接收來自 Flutter 的呼吸節奏 (0.0 ~ 1.0)
uniform float r;       // 顏色 R
uniform float g;       // 顏色 G
uniform float b;       // 顏色 B
uniform float a;       // 顏色透明度

out vec4 fragColor;

void main() {
    // 取得當前像素座標並置中
    vec2 uv = FlutterFragCoord().xy / uSize;
    vec2 center = vec2(0.5, 0.5);
    float d = distance(uv, center);
    
    // 根據 uBreath 動態改變光暈大小與亮度
    float radius = 0.25 + (uBreath * 0.15);
    float intensity = 1.0 - smoothstep(0.0, radius, d);
    
    // 增加光暈的邊緣衰減層次感 (Neon 質感)
    intensity = pow(intensity, 1.8) * (0.6 + uBreath * 0.6);
    
    // 輸出最終像素顏色
    vec4 color = vec4(r, g, b, a);
    fragColor = color * intensity;
}