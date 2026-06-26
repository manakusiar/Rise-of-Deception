shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform vec2 square_ratio = vec2(640.0, 360.0);
uniform float square_size = 8.0;
uniform vec2 direction = vec2(1.0, 0.0);
uniform bool fade_in = false;
uniform float edge_softness : hint_range(0.0, 1.0) = 0.15;
uniform float v_strength : hint_range(-1.0, 1.0) = 0.35;

void fragment() {
    vec4 tex = COLOR;
    vec2 dir = normalize(length(direction) < 0.001 ? vec2(1.0, 0.0) : direction);

    // Pixelation logic
    vec2 cell_count = square_ratio / square_size;
    vec2 cell = floor(UV * cell_count);
    vec2 cell_center = (cell + 0.5) / cell_count;

    // 1. Calculate the linear progress along the direction (0.0 to 1.0)
    float projected = dot(cell_center, dir);
    float c0 = dot(vec2(0.0, 0.0), dir);
    float c1 = dot(vec2(1.0, 0.0), dir);
    float c2 = dot(vec2(0.0, 1.0), dir);
    float c3 = dot(vec2(1.0, 1.0), dir);
    float min_p = min(min(c0, c1), min(c2, c3));
    float max_p = max(max(c0, c1), max(c2, c3));
    float order_base = (projected - min_p) / max(max_p - min_p, 0.0001);

    // 2. Calculate distance from the center line for the V shape (0.0 to 1.0)
    vec2 perp = vec2(-dir.y, dir.x);
    float center_distance = abs(dot(cell_center - vec2(0.5), perp));
    float d0 = abs(dot(vec2(0.0, 0.0) - vec2(0.5), perp));
    float d1 = abs(dot(vec2(1.0, 0.0) - vec2(0.5), perp));
    float d2 = abs(dot(vec2(0.0, 1.0) - vec2(0.5), perp));
    float d3 = abs(dot(vec2(1.0, 1.0) - vec2(0.5), perp));
    float max_d = max(max(d0, d1), max(d2, d3));
    center_distance /= max(max_d, 0.0001);

    // 3. COMBINED ORDER (The "V" math)
    float order = order_base + (center_distance * v_strength);

    // 4. DYNAMIC RANGE CORRECTION
    // We calculate the absolute lowest and highest possible 'order' values
    float min_possible_order = min(0.0, v_strength);
    float max_possible_order = max(1.0, 1.0 + v_strength);
    
    // We expand the progress range to cover the order PLUS the softness margin
    // This ensures that at 0.0 it's fully empty and at 1.0 it's fully filled.
    float range_start = min_possible_order - edge_softness;
    float range_end = max_possible_order + edge_softness;
    float current_threshold = mix(range_start, range_end, progress);

    // 5. MASKING
    float mask = smoothstep(
        current_threshold - edge_softness,
        current_threshold + edge_softness,
        order
    );

    // Logic for Fade In vs Fade Out
    if (fade_in) {
        mask = 1.0 - mask;
    }

    tex.a *= mask;
    COLOR = tex;
}