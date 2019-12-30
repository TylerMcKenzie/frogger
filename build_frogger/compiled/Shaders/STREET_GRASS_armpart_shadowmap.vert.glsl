#version 450
in vec4 pos;
in vec3 ipos;
uniform mat4 pd;
uniform mat4 LWVP;
float fhash(float n) { return fract(sin(n) * 43758.5453); }
void main() {
vec4 spos = vec4(pos.xyz, 1.0);
	spos.xyz += ipos;
	float p_age = pd[3][3] - gl_InstanceID * pd[0][1];
	p_age -= p_age * fhash(gl_InstanceID) * pd[2][3];
	if (pd[0][0] > 0 && p_age < 0) p_age += (int(-p_age / pd[0][0]) + 1) * pd[0][0];
	float p_lifetime = pd[0][2];
	if (p_age < 0 || p_age > p_lifetime) {
	    gl_Position /= 0.0;
	    return;
	}
	vec3 p_velocity = vec3(pd[1][0], pd[1][1], pd[1][2]);
	p_velocity.x += fhash(gl_InstanceID)                * pd[1][3] - pd[1][3] / 2;
	p_velocity.y += fhash(gl_InstanceID +     pd[0][3]) * pd[1][3] - pd[1][3] / 2;
	p_velocity.z += fhash(gl_InstanceID + 2 * pd[0][3]) * pd[1][3] - pd[1][3] / 2;
	p_velocity.x += (pd[2][0] * p_age) / 5;
	p_velocity.y += (pd[2][1] * p_age) / 5;
	p_velocity.z += (pd[2][2] * p_age) / 5;
	vec3 p_location = p_velocity * p_age;
	spos.xyz += p_location;
	gl_Position = LWVP * spos;
}
