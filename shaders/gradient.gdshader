shader_type canvas_item;

uniform vec4 color_center : source_color = vec4(1.0, 0.8, 0.0, 1.0);
uniform vec4 color_edge : source_color = vec4(0.1, 0.1, 0.2, 1.0);

uniform float radius : hint_range(0.0, 1.5) = 0.3;
uniform float smoothness : hint_range(0.0, 1.0) = 0.2;

void fragment() {
    float dist = distance(UV, vec2(0.5, 0.5));
    
    float t = smoothstep(radius - smoothness, radius + smoothness, dist);
    
    COLOR = mix(color_center, color_edge, t);
}
