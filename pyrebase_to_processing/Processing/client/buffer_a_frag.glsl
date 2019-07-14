#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#version 330
#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texMap;
uniform sampler2D lastFrame;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main()
{
    vec2 uv = vertTexCoord.st;
    vec4 new = texture(texMap, vec2(1.0- uv.x, uv.y));

    float zoom = .999;
    uv-=.5;
    uv*=zoom;
    uv+=.5;
    vec4 last = texture(lastFrame, vec2(uv.x,1.0-uv.y));

    gl_FragColor = mix(new,last,.95);
}
