#version 110
#ifdef GL_ARB_shading_language_420pack
#extension GL_ARB_shading_language_420pack : require
#endif

uniform float texUnpack;
uniform mat3 N;
uniform mat4 WVP;

attribute vec4 pos;
varying vec2 texCoord;
attribute vec2 tex;
varying vec3 wnormal;
attribute vec2 nor;
attribute vec3 iscl;
attribute vec3 ipos;

void main()
{
    vec4 spos = vec4(pos.xyz, 1.0);
    texCoord = tex * texUnpack;
    wnormal = normalize(N * vec3(nor, pos.w));
    vec3 _53 = spos.xyz * iscl;
    spos = vec4(_53.x, _53.y, _53.z, spos.w);
    vec3 _60 = spos.xyz + ipos;
    spos = vec4(_60.x, _60.y, _60.z, spos.w);
    gl_Position = WVP * spos;
}

