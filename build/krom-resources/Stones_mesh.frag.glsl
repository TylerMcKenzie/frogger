#version 110
#ifdef GL_ARB_shading_language_420pack
#extension GL_ARB_shading_language_420pack : require
#endif

varying vec3 wnormal;

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
    vec3 basecol = vec3(0.2202575504779815673828125);
    float roughness = 0.72818791866302490234375;
    float metallic = 0.0;
    float occlusion = 1.0;
    float specular = 0.647651016712188720703125;
    n /= vec3((abs(n.x) + abs(n.y)) + abs(n.z));
    vec2 _95;
    if (n.z >= 0.0)
    {
        _95 = n.xy;
    }
    else
    {
        _95 = octahedronWrap(n.xy);
    }
    n = vec3(_95.x, _95.y, n.z);
    gl_out[0].gl_FragData = vec4(n.xy, roughness, packFloatInt16(metallic, 0u));
    gl_out[1].gl_FragData = vec4(basecol, packFloat2(occlusion, specular));
}

