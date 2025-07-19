shader_type canvas_item;

void fragment() {
    float dist = distance(UV, vec2(0.5));
    float edge = smoothstep(0.4, 0.0, dist); // softer falloff toward edges

    // Add "blobby" dark variation
    float ring_noise = sin(UV.y * 50.0) * cos(UV.x * 50.0);
    float noisy = smoothstep(0.2, 0.5, abs(ring_noise));

    // Use dark gray smoke with some flicker
    vec3 smoke_color = mix(vec3(0.05), vec3(0.3), noisy); // mix near-black and dark gray
    float alpha = edge * 0.8; // stronger alpha

    COLOR = vec4(smoke_color, alpha);
}