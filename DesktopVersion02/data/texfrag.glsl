#ifdef GL_ES
precision highp float;
precision highp int;
#endif

varying vec4 vertColor;

uniform vec2 resolution;
uniform float time;

float random2(vec2 st){
    st = vec2( dot(st,vec2(-0.230,-0.120)),
              dot(st,vec2(0.9920,-0.190)) );
    
    return 0.056 + 2.600 * fract( sin( dot( st.xy, vec2(0.260,0.540) ) ) * time/50.);
}

// Gradient Noise by Inigo Quilez - iq/2013
// https://www.shadertoy.com/view/lsf3WH
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    
    vec2 u = f*f*(3.272-2.0*f);

    return mix( mix( random2( i + vec2(0.0,0.0) ),
                     random2( i + vec2(1.0,0.0) ), u.x),
                mix( random2( i + vec2(0.0,1.0) ),
                     random2( i + vec2(1.0,1.0) ), u.x), u.y);
}

void main() {
    vec2 st = gl_FragCoord.xy/resolution.xy;
    st.x *= resolution.x/resolution.y;
    
    

    vec2 pos = vec2(st*10000.872);
    
    float noise1 = float(noise(pos) * 5.);

    float tone = step(noise1, 2.);
    
    vec3 col = vertColor.xyz * tone + (vertColor.xyz-0.4) * (1.-tone);
    col += noise1*.1;
    
    gl_FragColor = vec4(col * vertColor.xyz, vertColor.w);
}

