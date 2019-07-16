
#define PROCESSING_TEXTURE_SHADER

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texMap;
uniform vec2 texOffset;

varying vec4 vertColor;
varying vec4 vertTexCoord;

mat3 sx = mat3(
    1.0, 2.0, 1.0,
    0.0, 0.0, 0.0,
   -1.0, -2.0, -1.0
);
mat3 sy = mat3(
    1.0, 0.0, -1.0,
    2.0, 0.0, -2.0,
    1.0, 0.0, -1.0
);

void main()
{
  float z = 45.0;

  mat3 I;
  I[0][0] = length(texture2D(texMap, vertTexCoord.st + vec2(-texOffset.s, -texOffset.t)).rgb);
  I[0][1] = length(texture2D(texMap, vertTexCoord.st + vec2(-texOffset.s, 0.0)).rgb);
  I[0][2] = length(texture2D(texMap, vertTexCoord.st + vec2(-texOffset.s, +texOffset.t)).rgb);

  I[1][0] = length(texture2D(texMap, vertTexCoord.st + vec2(0.0, -texOffset.t)).rgb);
  I[1][1] = length(texture2D(texMap, vertTexCoord.st + vec2(0.0, 0.0)).rgb);
  I[1][2] = length(texture2D(texMap, vertTexCoord.st + vec2(0.0, +texOffset.t)).rgb);

  I[2][0] = length(texture2D(texMap, vertTexCoord.st + vec2(+texOffset.s, -texOffset.t)).rgb);
  I[2][1] = length(texture2D(texMap, vertTexCoord.st + vec2(+texOffset.s, 0.0)).rgb);
  I[2][2] = length(texture2D(texMap, vertTexCoord.st + vec2(+texOffset.s, +texOffset.t)).rgb);

  float gx = dot(sx[0], I[0]) + dot(sx[1], I[1]) + dot(sx[2], I[2]);
  float gy = dot(sy[0], I[0]) + dot(sy[1], I[1]) + dot(sy[2], I[2]);

  float g = sqrt(pow(gx, 2.0)+pow(gy, 2.0));
  vec4 color = vec4(vec3(g), 1.0);
  gl_FragColor = color;
}
