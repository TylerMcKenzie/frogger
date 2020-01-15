#version 110
#ifdef GL_ARB_shading_language_420pack
#extension GL_ARB_shading_language_420pack : require
#endif

uniform mat4 LWVP;

attribute vec4 pos;
attribute vec3 iscl;
attribute vec3 ipos;

void main()
{
    vec4 spos = vec4(pos.xyz, 1.0);
    vec3 _25 = spos.xyz * iscl;
    spos = vec4(_25.x, _25.y, _25.z, spos.w);
    vec3 _32 = spos.xyz + ipos;
    spos = vec4(_32.x, _32.y, _32.z, spos.w);
    gl_Position = LWVP * spos;
}

