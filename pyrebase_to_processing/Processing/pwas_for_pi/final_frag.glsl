#define PROCESSING_TEXTURE_SHADER

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform float u_time;
uniform float speed_2;
uniform sampler2D texMap;
uniform sampler2D bufferB;

varying vec4 vertColor;
varying vec4 vertTexCoord;

//Final Output
void main()
{
  vec2 uv = vertTexCoord.st;
	vec4 c = texture2D(texMap, uv);
  vec4 c2 = texture2D(bufferB, uv);
  float speed = 40.;
  float strength = .005;
  c.rgb = sin(c.rgb*(speed)+u_time+vec3(3., 1.5, strength))*.5+.5;
  c2.rgb = sin(c.rgb*(speed_2)+u_time+vec3(3., 1.5, strength))*.5+.5;
  gl_FragColor = mix(c, c2, .5);
}
