#version 110
#ifdef GL_ARB_shading_language_420pack
#extension GL_ARB_shading_language_420pack : require
#endif

varying vec3 color;

void main()
{
    gl_out[0].gl_FragData = vec4(1.0, 1.0, 0.0, 1.0);
    gl_out[1].gl_FragData = vec4(color, 1.0);
}

