#version 330
#ifdef GL_ARB_shading_language_420pack
#extension GL_ARB_shading_language_420pack : require
#endif

uniform vec4 casData[20];
uniform vec4 shirr[7];
uniform vec3 backgroundCol;
uniform float envmapStrength;
uniform vec3 sunDir;
uniform bool receiveShadow;
uniform sampler2DShadow shadowMap;
uniform vec3 eye;
uniform float shadowsBias;
uniform vec3 sunCol;

in vec3 wnormal;
in vec3 eyeDir;
in vec3 wposition;
out vec4 fragColor[1];

vec3 surfaceAlbedo(vec3 baseColor, float metalness)
{
    return mix(baseColor, vec3(0.0), vec3(metalness));
}

vec3 surfaceF0(vec3 baseColor, float metalness)
{
    return mix(vec3(0.039999999105930328369140625), baseColor, vec3(metalness));
}

vec3 shIrradiance(vec3 nor)
{
    vec3 cl00 = vec3(shirr[0].x, shirr[0].y, shirr[0].z);
    vec3 cl1m1 = vec3(shirr[0].w, shirr[1].x, shirr[1].y);
    vec3 cl10 = vec3(shirr[1].z, shirr[1].w, shirr[2].x);
    vec3 cl11 = vec3(shirr[2].y, shirr[2].z, shirr[2].w);
    vec3 cl2m2 = vec3(shirr[3].x, shirr[3].y, shirr[3].z);
    vec3 cl2m1 = vec3(shirr[3].w, shirr[4].x, shirr[4].y);
    vec3 cl20 = vec3(shirr[4].z, shirr[4].w, shirr[5].x);
    vec3 cl21 = vec3(shirr[5].y, shirr[5].z, shirr[5].w);
    vec3 cl22 = vec3(shirr[6].x, shirr[6].y, shirr[6].z);
    return ((((((((((cl22 * 0.429042994976043701171875) * ((nor.y * nor.y) - ((-nor.z) * (-nor.z)))) + (((cl20 * 0.743125021457672119140625) * nor.x) * nor.x)) + (cl00 * 0.88622701168060302734375)) - (cl20 * 0.2477079927921295166015625)) + (((cl2m2 * 0.85808598995208740234375) * nor.y) * (-nor.z))) + (((cl21 * 0.85808598995208740234375) * nor.y) * nor.x)) + (((cl2m1 * 0.85808598995208740234375) * (-nor.z)) * nor.x)) + ((cl11 * 1.02332794666290283203125) * nor.y)) + ((cl1m1 * 1.02332794666290283203125) * (-nor.z))) + ((cl10 * 1.02332794666290283203125) * nor.x);
}

mat4 getCascadeMat(float d, inout int casi, inout int casIndex)
{
    vec4 comp = vec4(float(d > casData[16].x), float(d > casData[16].y), float(d > casData[16].z), float(d > casData[16].w));
    casi = int(min(dot(vec4(1.0), comp), 4.0));
    casIndex = casi * 4;
    return mat4(vec4(casData[casIndex]), vec4(casData[casIndex + 1]), vec4(casData[casIndex + 2]), vec4(casData[casIndex + 3]));
}

float PCF(sampler2DShadow shadowMap_1, vec2 uv, float compare, vec2 smSize)
{
    vec3 _157 = vec3(uv + (vec2(-1.0) / smSize), compare);
    float result = texture(shadowMap_1, vec3(_157.xy, _157.z));
    vec3 _166 = vec3(uv + (vec2(-1.0, 0.0) / smSize), compare);
    result += texture(shadowMap_1, vec3(_166.xy, _166.z));
    vec3 _177 = vec3(uv + (vec2(-1.0, 1.0) / smSize), compare);
    result += texture(shadowMap_1, vec3(_177.xy, _177.z));
    vec3 _188 = vec3(uv + (vec2(0.0, -1.0) / smSize), compare);
    result += texture(shadowMap_1, vec3(_188.xy, _188.z));
    vec3 _196 = vec3(uv, compare);
    result += texture(shadowMap_1, vec3(_196.xy, _196.z));
    vec3 _207 = vec3(uv + (vec2(0.0, 1.0) / smSize), compare);
    result += texture(shadowMap_1, vec3(_207.xy, _207.z));
    vec3 _218 = vec3(uv + (vec2(1.0, -1.0) / smSize), compare);
    result += texture(shadowMap_1, vec3(_218.xy, _218.z));
    vec3 _229 = vec3(uv + (vec2(1.0, 0.0) / smSize), compare);
    result += texture(shadowMap_1, vec3(_229.xy, _229.z));
    vec3 _240 = vec3(uv + (vec2(1.0) / smSize), compare);
    result += texture(shadowMap_1, vec3(_240.xy, _240.z));
    return result / 9.0;
}

float shadowTestCascade(sampler2DShadow shadowMap_1, vec3 eye_1, vec3 p, float shadowsBias_1)
{
    float d = distance(eye_1, p);
    int param;
    int param_1;
    mat4 _340 = getCascadeMat(d, param, param_1);
    int casi = param;
    int casIndex = param_1;
    mat4 LWVP = _340;
    vec4 lPos = LWVP * vec4(p, 1.0);
    vec3 _355 = lPos.xyz / vec3(lPos.w);
    lPos = vec4(_355.x, _355.y, _355.z, lPos.w);
    float visibility = 1.0;
    if (lPos.w > 0.0)
    {
        visibility = PCF(shadowMap_1, lPos.xy, lPos.z - shadowsBias_1, vec2(4096.0, 1024.0));
    }
    float nextSplit = casData[16][casi];
    float _381;
    if (casi == 0)
    {
        _381 = nextSplit;
    }
    else
    {
        _381 = nextSplit - (casData[16][casi - 1]);
    }
    float splitSize = _381;
    float splitDist = (nextSplit - d) / splitSize;
    if ((splitDist <= 0.1500000059604644775390625) && (casi != 3))
    {
        int casIndex2 = casIndex + 4;
        mat4 LWVP2 = mat4(vec4(casData[casIndex2]), vec4(casData[casIndex2 + 1]), vec4(casData[casIndex2 + 2]), vec4(casData[casIndex2 + 3]));
        vec4 lPos2 = LWVP2 * vec4(p, 1.0);
        vec3 _459 = lPos2.xyz / vec3(lPos2.w);
        lPos2 = vec4(_459.x, _459.y, _459.z, lPos2.w);
        float visibility2 = 1.0;
        if (lPos2.w > 0.0)
        {
            visibility2 = PCF(shadowMap_1, lPos2.xy, lPos2.z - shadowsBias_1, vec2(4096.0, 1024.0));
        }
        float lerpAmt = smoothstep(0.0, 0.1500000059604644775390625, splitDist);
        return mix(visibility2, visibility, lerpAmt);
    }
    return visibility;
}

vec3 lambertDiffuseBRDF(vec3 albedo, float nl)
{
    return albedo * max(0.0, nl);
}

float d_ggx(float nh, float a)
{
    float a2 = a * a;
    float denom = pow(((nh * nh) * (a2 - 1.0)) + 1.0, 2.0);
    return (a2 * 0.3183098733425140380859375) / denom;
}

float v_smithschlick(float nl, float nv, float a)
{
    return 1.0 / (((nl * (1.0 - a)) + a) * ((nv * (1.0 - a)) + a));
}

vec3 f_schlick(vec3 f0, float vh)
{
    return f0 + ((vec3(1.0) - f0) * exp2((((-5.554729938507080078125) * vh) - 6.9831600189208984375) * vh));
}

vec3 specularBRDF(vec3 f0, float roughness, float nl, float nh, float nv, float vh)
{
    float a = roughness * roughness;
    return (f_schlick(f0, vh) * (d_ggx(nh, a) * clamp(v_smithschlick(nl, nv, a), 0.0, 1.0))) / vec3(4.0);
}

void main()
{
    vec3 n = normalize(wnormal);
    vec3 vVec = normalize(eyeDir);
    float dotNV = max(dot(n, vVec), 0.0);
    vec3 basecol = vec3(0.0053576640784740447998046875, 0.237730324268341064453125, 0.00436325557529926300048828125);
    float roughness = 0.4999999701976776123046875;
    float metallic = 0.0;
    float occlusion = 1.0;
    float specular = 1.0;
    vec3 albedo = surfaceAlbedo(basecol, metallic);
    vec3 f0 = surfaceF0(basecol, metallic);
    vec3 indirect = shIrradiance(n);
    indirect *= albedo;
    indirect += (backgroundCol * f0);
    indirect *= occlusion;
    indirect *= envmapStrength;
    vec3 direct = vec3(0.0);
    float svisibility = 1.0;
    vec3 sh = normalize(vVec + sunDir);
    float sdotNL = dot(n, sunDir);
    float sdotNH = dot(n, sh);
    float sdotVH = dot(vVec, sh);
    if (receiveShadow)
    {
        svisibility = shadowTestCascade(shadowMap, eye, wposition + ((n * shadowsBias) * 10.0), shadowsBias);
    }
    direct += (((lambertDiffuseBRDF(albedo, sdotNL) + (specularBRDF(f0, roughness, sdotNL, sdotNH, dotNV, sdotVH) * specular)) * sunCol) * svisibility);
    fragColor[0] = vec4(direct + indirect, 1.0);
}
