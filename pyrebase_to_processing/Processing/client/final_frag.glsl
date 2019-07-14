#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

//#version 330
#define PROCESSING_TEXTURE_SHADER

uniform float u_time;
uniform sampler2D texMap;
uniform sampler2D bufferB;

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform float strength_2;

//Final Output
void main()
{
  vec2 uv = vertTexCoord.st;
	vec4 c = texture(texMap, uv);
  vec4 c2 = texture(bufferB, uv);
  float speed = 40.;
  float strength = .005;
  c.rgb = sin(c.rgb*(speed)+u_time+vec3(3., 1.5, strength))*.5+.5;
  c2.rgb = sin(c.rgb*(speed)+u_time+vec3(3., 1.5, strength_2))*.5+.5;
  gl_FragColor = mix(c, c2, .5);
}
