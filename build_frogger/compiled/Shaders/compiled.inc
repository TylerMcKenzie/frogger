#ifndef _COMPILED_GLSL_
#define _COMPILED_GLSL_
#define _Irr
#define _EnvCol
#define _EnvClouds
#define _EnvStr
#define _ShadowMap
#define _CSM
#define _Sun
#define _SMAA
#define _SSAO
#define _CToneFilmic
const float PI = 3.1415926535;
const float PI2 = PI * 2.0;
const vec2 shadowmapSize = vec2(1024, 1024);
const float shadowmapCubePcfSize = 0.001;
const int shadowmapCascades = 4;
const float cloudsLower = 1.0;
const float cloudsUpper = 1.0;
const vec2 cloudsWind = vec2(1.0, 0.0);
const float cloudsPrecipitation = 1.0;
const float cloudsSecondary = 1.0;
const int cloudsSteps = 24;
const float ssaoRadius = 1.0;
const float ssaoStrength = 1.0;
const float ssaoScale = 20.0;
const int skinMaxBones = 8;

#endif // _COMPILED_GLSL_
