#version 110
#ifdef GL_ARB_shading_language_420pack
#extension GL_ARB_shading_language_420pack : require
#endif

uniform sampler2D ImageTexture;

varying vec3 wnormal;
varying vec2 texCoord;

vec2 octahedronWrap(vec2 v)
{
    return (vec2(1.0) - abs(v.yx)) * vec2((v.x >= 0.0) ? 1.0 : (-1.0), (v.y >= 0.0) ? 1.0 : (-1.0));
}

float packFloatInt16(float f, uint i)
{
    return (0.06248569488525390625 * f) + (0.06250095367431640625 * float(i));
}

float packFloat2(float f1, float f2)
{
    return floor(f1 * 255.0) + min(f2, 0.9900000095367431640625);
}

void main()
{
    vec3 n = normalize(wnormal);
    vec4 ImageTexture_texread_store = texture2D(ImageTexture, texCoord);
    vec3 _82 = pow(ImageTexture_texread_store.xyz, vec3(2.2000000476837158203125));
    ImageTexture_texread_store = vec4(_82.x, _82.y, _82.z, ImageTexture_texread_store.w);
    vec3 ImageTexture_Color_res = ImageTexture_texread_store.xyz;
    vec3 basecol = ImageTexture_Color_res;
    float roughness = 0.100000001490116119384765625;
    float metallic = 0.0;
    float occlusion = 1.0;
    float specular = 1.0;
    n /= vec3((abs(n.x) + abs(n.y)) + abs(n.z));
    vec2 _115;
    if (n.z >= 0.0)
    {
        _115 = n.xy;
    }
    else
    {
        _115 = octahedronWrap(n.xy);
    }
    n = vec3(_115.x, _115.y, n.z);
    gl_out[0].gl_FragData = vec4(n.xy, roughness, packFloatInt16(metallic, 0u));
    gl_out[1].gl_FragData = vec4(basecol, packFloat2(occlusion, specular));
}

