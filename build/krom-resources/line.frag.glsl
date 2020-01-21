#version 110
#ifdef GL_ARB_shading_language_420pack
#extension GL_ARB_shading_language_420pack : require
#endif

varying vec3 color;

void main()
{
    gl_FragData[0] = vec4(color, 1.0);
}

