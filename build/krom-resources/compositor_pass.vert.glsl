#version 110
#ifdef GL_ARB_shading_language_420pack
#extension GL_ARB_shading_language_420pack : require
#endif

varying vec2 texCoord;
attribute vec2 pos;

void main()
{
    texCoord = (pos * vec2(0.5)) + vec2(0.5);
    gl_Position = vec4(pos, 0.0, 1.0);
}

