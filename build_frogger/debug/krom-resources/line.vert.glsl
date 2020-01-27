#version 330
#ifdef GL_ARB_shading_language_420pack
#extension GL_ARB_shading_language_420pack : require
#endif

uniform mat4 ViewProjection;

out vec3 color;
in vec3 col;
in vec3 pos;

void main()
{
    color = col;
    gl_Position = ViewProjection * vec4(pos, 1.0);
}

