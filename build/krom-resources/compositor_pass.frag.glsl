#version 110
#ifdef GL_ARB_shading_language_420pack
#extension GL_ARB_shading_language_420pack : require
#endif
#extension GL_ARB_shader_texture_lod : require

uniform sampler2D tex;

varying vec2 texCoord;

vec3 tonemapFilmic(vec3 color)
{
    vec3 x = max(vec3(0.0), color - vec3(0.0040000001899898052215576171875));
    return (x * ((x * 6.19999980926513671875) + vec3(0.5))) / ((x * ((x * 6.19999980926513671875) + vec3(1.7000000476837158203125))) + vec3(0.0599999986588954925537109375));
}

void main()
{
    vec2 texCo = texCoord;
    gl_FragData[0] = texture2DLod(tex, texCo, 0.0);
    vec3 _59 = tonemapFilmic(gl_FragData[0].xyz);
    gl_FragData[0] = vec4(_59.x, _59.y, _59.z, gl_FragData[0].w);
}

