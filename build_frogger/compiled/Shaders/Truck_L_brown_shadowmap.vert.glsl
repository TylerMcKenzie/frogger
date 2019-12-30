#version 450
in vec4 pos;
in vec3 ipos;
in vec3 iscl;
uniform mat4 LWVP;
void main() {
vec4 spos = vec4(pos.xyz, 1.0);
	spos.xyz *= iscl;
	spos.xyz += ipos;
	gl_Position = LWVP * spos;
}
