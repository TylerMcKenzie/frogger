#version 330
#ifdef GL_ARB_shading_language_420pack
#extension GL_ARB_shading_language_420pack : require
#endif

uniform mat3 N;
uniform mat4 WVP;

in vec4 pos;
out vec3 wnormal;
in vec2 nor;
in vec3 ipos;

void main()
{
    vec4 spos = vec4(pos.xyz, 1.0);
    wnormal = normalize(N * vec3(nor, pos.w));
    vec3 _45 = spos.xyz + ipos;
    spos = vec4(_45.x, _45.y, _45.z, spos.w);
    gl_Position = WVP * spos;
}

