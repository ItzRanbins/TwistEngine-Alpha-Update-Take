#pragma header

uniform vec3 u_topColor;
uniform vec3 u_botColor;

float vividLight(float base, float blend) {
    return (blend < 0.5) ? (1.0 - (1.0 - base) / (2.0 * blend + 0.0001)) : (base / (2.0 * (1.0 - blend) + 0.0001));
}

float hardLight(float base, float blend) {
    return (blend < 0.5) ? (2.0 * base * blend) : (1.0 - 2.0 * (1.0 - base) * (1.0 - blend));
}

void main()
{
    vec2 st = openfl_TextureCoordv;

    vec4 texColor = texture2D(bitmap, st);

    float grad1 = st.y;
    vec3 col;
    col.r = vividLight(texColor.r, mix(0.5, 0.1529, grad1));
    col.g = vividLight(texColor.g, mix(0.5, 0.1529, grad1));
    col.b = vividLight(texColor.b, mix(0.5, 0.1529, grad1));

    float gray = dot(col, vec3(0.299, 0.587, 0.114));
    vec3 baseLayer = vec3(gray);

    vec3 gradientColor = mix(u_topColor, u_botColor, st.y);

    vec3 finalColor;
    finalColor.r = hardLight(baseLayer.r, gradientColor.r);
    finalColor.g = hardLight(baseLayer.g, gradientColor.g);
    finalColor.b = hardLight(baseLayer.b, gradientColor.b);

    gl_FragColor = vec4(finalColor, texColor.a);
}