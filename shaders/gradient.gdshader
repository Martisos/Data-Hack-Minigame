shader_type canvas_item;

uniform vec4 color_center : source_color = vec4(1.0, 0.8, 0.0, 1.0);
uniform vec4 color_edge : source_color = vec4(0.1, 0.1, 0.2, 1.0);

uniform float radius : hint_range(0.0, 1.5) = 0.3;
uniform float smoothness : hint_range(0.0, 1.0) = 0.2;

uniform float pulse_speed : hint_range(0.0, 10.0) = 2.0;
uniform float pulse_strength : hint_range(0.0, 0.5) = 0.05;

void fragment() {
    float dist = distance(UV, vec2(0.5, 0.5));
    
    float dynamic_radius = radius + sin(TIME * pulse_speed) * pulse_strength;
    
    float t = smoothstep(dynamic_radius - smoothness, dynamic_radius + smoothness, dist);
    
    COLOR = mix(color_center, color_edge, t);
}