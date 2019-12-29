#version 450
in vec4 pos;
in vec2 nor;
in vec2 tex;
in vec3 ipos;
in vec3 iscl;
out vec2 texCoord;
out vec3 wnormal;
uniform mat3 N;
uniform mat4 WVP;
uniform float texUnpack;
void main() {
vec4 spos = vec4(pos.xyz, 1.0);
texCoord = tex * texUnpack;
	wnormal = normalize(N * vec3(nor.xy, pos.w));
	spos.xyz *= iscl;
	spos.xyz += ipos;
	gl_Position = WVP * spos;
}
