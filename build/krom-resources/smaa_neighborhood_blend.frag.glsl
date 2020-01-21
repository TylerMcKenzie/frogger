#version 110
#ifdef GL_ARB_shading_language_420pack
#extension GL_ARB_shading_language_420pack : require
#endif
#extension GL_ARB_shader_texture_lod : require

uniform sampler2D blendTex;
uniform sampler2D colorTex;
uniform vec2 screenSizeInv;

varying vec2 texCoord;
varying vec4 offset;

vec4 textureLodA(sampler2D tex, vec2 coords, float lod)
{
    return texture2DLod(tex, coords, lod);
}

vec4 SMAANeighborhoodBlendingPS(vec2 texcoord, vec4 offset_1)
{
    vec4 a;
    a.x = texture2DLod(blendTex, offset_1.xy, 0.0).w;
    a.y = texture2DLod(blendTex, offset_1.zw, 0.0).y;
    vec2 _54 = texture2DLod(blendTex, texcoord, 0.0).xz;
    a = vec4(a.x, a.y, _54.y, _54.x);
    if (dot(a, vec4(1.0)) < 9.9999997473787516355514526367188e-06)
    {
        vec4 color = texture2DLod(colorTex, texcoord, 0.0);
        return color;
    }
    else
    {
        bool h = max(a.x, a.z) > max(a.y, a.w);
        vec4 blendingOffset = vec4(0.0, a.y, 0.0, a.w);
        vec2 blendingWeight = a.yw;
        if (h)
        {
            blendingOffset.x = a.x;
            blendingOffset.y = 0.0;
            blendingOffset.z = a.z;
            blendingOffset.w = 0.0;
            blendingWeight.x = a.x;
            blendingWeight.y = a.z;
        }
        blendingWeight /= vec2(dot(blendingWeight, vec2(1.0)));
        vec2 tc = texcoord;
        vec4 blendingCoord = (blendingOffset * vec4(screenSizeInv, -screenSizeInv)) + tc.xyxy;
        vec2 param = blendingCoord.xy;
        float param_1 = 0.0;
        vec4 color_1 = textureLodA(colorTex, param, param_1) * blendingWeight.x;
        vec2 param_2 = blendingCoord.zw;
        float param_3 = 0.0;
        color_1 += (textureLodA(colorTex, param_2, param_3) * blendingWeight.y);
        return color_1;
    }
    return vec4(0.0);
}

void main()
{
    vec2 param = texCoord;
    vec4 param_1 = offset;
    gl_FragData[0] = SMAANeighborhoodBlendingPS(param, param_1);
}

