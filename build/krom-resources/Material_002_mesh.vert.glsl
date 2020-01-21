#version 110
#ifdef GL_ARB_shading_language_420pack
#extension GL_ARB_shading_language_420pack : require
#endif

uniform mat3 N;
uniform mat4 WVP;

attribute vec4 pos;
varying vec3 wnormal;
attribute vec2 nor;

void main()
{
    vec4 spos = vec4(pos.xyz, 1.0);
    wnormal = normalize(N * vec3(nor, pos.w));
    gl_Position = WVP * spos;
}

