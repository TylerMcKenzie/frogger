#version 330
#ifdef GL_ARB_shading_language_420pack
#extension GL_ARB_shading_language_420pack : require
#endif

uniform sampler3D scloudsBase;
uniform sampler2D scloudsMap;
uniform sampler3D scloudsDetail;
uniform float time;
uniform vec3 backgroundCol;
uniform float envmapStrength;

out vec4 fragColor;
in vec3 normal;

float getDensityHeightGradientForPoint(float height, float cloud_type)
{
    float stratus = 1.0 - clamp(cloud_type * 2.0, 0.0, 1.0);
    float stratocumulus = 1.0 - (abs(cloud_type - 0.5) * 2.0);
    float cumulus = clamp(cloud_type - 0.5, 0.0, 1.0) * 2.0;
    vec4 cloudGradient = ((vec4(0.0199999995529651641845703125, 0.0500000007450580596923828125, 0.0900000035762786865234375, 0.10999999940395355224609375) * stratus) + (vec4(0.0199999995529651641845703125, 0.20000000298023223876953125, 0.4799999892711639404296875, 0.625) * stratocumulus)) + (vec4(0.00999999977648258209228515625, 0.0625, 0.7799999713897705078125, 1.0) * cumulus);
    return smoothstep(cloudGradient.x, cloudGradient.y, height) - smoothstep(cloudGradient.z, cloudGradient.w, height);
}

float remap(float old_val, float old_min, float old_max, float new_min, float new_max)
{
    return new_min + (((old_val - old_min) / (old_max - old_min)) * (new_max - new_min));
}

float sampleCloudDensity(vec3 p)
{
    float cloud_base = textureLod(scloudsBase, p, 0.0).x * 40.0;
    vec3 weather_data = textureLod(scloudsMap, p.xy, 0.0).xyz;
    float param = p.z;
    float param_1 = weather_data.z;
    cloud_base *= getDensityHeightGradientForPoint(param, param_1);
    float param_2 = cloud_base;
    float param_3 = weather_data.x;
    float param_4 = 1.0;
    float param_5 = 0.0;
    float param_6 = 1.0;
    cloud_base = remap(param_2, param_3, param_4, param_5, param_6);
    cloud_base *= weather_data.x;
    float cloud_detail = textureLod(scloudsDetail, p, 0.0).x * 2.0;
    float cloud_detail_mod = mix(cloud_detail, 1.0 - cloud_detail, clamp(p.z * 10.0, 0.0, 1.0));
    float param_7 = cloud_base;
    float param_8 = cloud_detail_mod * 0.20000000298023223876953125;
    float param_9 = 1.0;
    float param_10 = 0.0;
    float param_11 = 1.0;
    cloud_base = remap(param_7, param_8, param_9, param_10, param_11);
    return cloud_base;
}

vec3 traceClouds(vec3 sky, vec3 dir)
{
    float T = 1.0;
    float C = 0.0;
    vec2 uv = (((dir.xy / vec2(dir.z)) * 0.4000000059604644775390625) * 1.0) + ((vec2(1.0, 0.0) * time) * 0.0199999995529651641845703125);
    for (int i = 0; i < 24; i++)
    {
        float h = float(i) / 24.0;
        vec3 p = vec3(uv * 0.039999999105930328369140625, h);
        vec3 param = p;
        float d = sampleCloudDensity(param);
        if (d > 0.0)
        {
            C += (((((T * exp(h)) * d) * 0.02083333395421504974365234375) * 0.60000002384185791015625) * 1.0);
            T *= exp((-d) * 0.02083333395421504974365234375);
            if (T < 0.00999999977648258209228515625)
            {
                break;
            }
        }
        uv += (((dir.xy / vec2(dir.z)) * 0.02083333395421504974365234375) * 1.0);
    }
    return vec3(C) + (sky * T);
}

void main()
{
    fragColor = vec4(backgroundCol.x, backgroundCol.y, backgroundCol.z, fragColor.w);
    vec3 n = normalize(normal);
    if (n.z > 0.0)
    {
        vec3 param = fragColor.xyz;
        vec3 param_1 = n;
        vec3 _314 = mix(fragColor.xyz, traceClouds(param, param_1), vec3(clamp(n.z * 5.0, 0.0, 1.0)));
        fragColor = vec4(_314.x, _314.y, _314.z, fragColor.w);
    }
    fragColor.w = 0.0;
}

