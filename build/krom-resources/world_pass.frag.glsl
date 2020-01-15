#version 110
#ifdef GL_ARB_shading_language_420pack
#extension GL_ARB_shading_language_420pack : require
#endif

uniform vec3 backgroundCol;

varying vec3 normal;

void main()
{
    gl_FragData[0] = vec4(backgroundCol.x, backgroundCol.y, backgroundCol.z, gl_FragData[0].w);
    gl_FragData[0].w = 0.0;
}

