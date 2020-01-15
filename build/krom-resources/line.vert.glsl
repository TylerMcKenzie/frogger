#version 110
#ifdef GL_ARB_shading_language_420pack
#extension GL_ARB_shading_language_420pack : require
#endif

uniform mat4 ViewProjection;

varying vec3 color;
attribute vec3 col;
attribute vec3 pos;

void main()
{
    color = col;
    gl_Position = ViewProjection * vec4(pos, 1.0);
}

