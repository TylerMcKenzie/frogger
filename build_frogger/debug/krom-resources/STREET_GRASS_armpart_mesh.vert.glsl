#version 330
#ifdef GL_ARB_shading_language_420pack
#extension GL_ARB_shading_language_420pack : require
#endif

uniform mat3 N;
uniform mat4 pd;
uniform mat4 WVP;

in vec4 pos;
out vec3 wnormal;
in vec2 nor;
in vec3 ipos;

float fhash(float n)
{
    return fract(sin(n) * 43758.546875);
}

void main()
{
    vec4 spos = vec4(pos.xyz, 1.0);
    wnormal = normalize(N * vec3(nor, pos.w));
    vec3 _57 = spos.xyz + ipos;
    spos = vec4(_57.x, _57.y, _57.z, spos.w);
    float p_age = pd[3].w - (float(gl_InstanceID) * pd[0].y);
    float param = float(gl_InstanceID);
    p_age -= ((p_age * fhash(param)) * pd[2].w);
    if ((pd[0].x > 0.0) && (p_age < 0.0))
    {
        p_age += (float(int((-p_age) / pd[0].x) + 1) * pd[0].x);
    }
    float p_lifetime = pd[0].z;
    if ((p_age < 0.0) || (p_age > p_lifetime))
    {
        gl_Position /= vec4(0.0);
        return;
    }
    vec3 p_velocity = vec3(pd[1].x, pd[1].y, pd[1].z);
    float param_1 = float(gl_InstanceID);
    p_velocity.x += ((fhash(param_1) * pd[1].w) - (pd[1].w / 2.0));
    float param_2 = float(gl_InstanceID) + pd[0].w;
    p_velocity.y += ((fhash(param_2) * pd[1].w) - (pd[1].w / 2.0));
    float param_3 = float(gl_InstanceID) + (2.0 * pd[0].w);
    p_velocity.z += ((fhash(param_3) * pd[1].w) - (pd[1].w / 2.0));
    p_velocity.x += ((pd[2].x * p_age) / 5.0);
    p_velocity.y += ((pd[2].y * p_age) / 5.0);
    p_velocity.z += ((pd[2].z * p_age) / 5.0);
    vec3 p_location = p_velocity * p_age;
    vec3 _236 = spos.xyz + p_location;
    spos = vec4(_236.x, _236.y, _236.z, spos.w);
    gl_Position = WVP * spos;
}
