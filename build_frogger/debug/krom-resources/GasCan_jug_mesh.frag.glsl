#version 330
#ifdef GL_ARB_shading_language_420pack
#extension GL_ARB_shading_language_420pack : require
#endif

in vec3 wnormal;
out vec4 fragColor[2];

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
    vec3 basecol = vec3(0.80000007152557373046875, 0.001656029024161398410797119140625, 0.0011201114393770694732666015625);
    float roughness = 0.300000011920928955078125;
    float metallic = 0.0;
    float occlusion = 1.0;
    float specular = 1.0;
    float emission = 0.0;
    n /= vec3((abs(n.x) + abs(n.y)) + abs(n.z));
    vec2 _97;
    if (n.z >= 0.0)
    {
        _97 = n.xy;
    }
    else
    {
        _97 = octahedronWrap(n.xy);
    }
    n = vec3(_97.x, _97.y, n.z);
    uint matid = 0u;
    if (emission > 0.0)
    {
        basecol *= emission;
        matid = 1u;
    }
    fragColor[0] = vec4(n.xy, roughness, packFloatInt16(metallic, matid));
    fragColor[1] = vec4(basecol, packFloat2(occlusion, specular));
}
