shader_type spatial;
render_mode unshaded, depth_draw_never, cull_disabled;

// --- Paramètres globaux ---
uniform float uv_scale = 10.0;            
uniform vec2 scroll_speed_layer1 = vec2(-0.002, 0.0);  // vers la droite
uniform vec2 scroll_speed_layer2 = vec2(-0.0007, 0.0); // couche lointaine plus lente

// --- Couche 1 (proche) ---
uniform float star_density1 = 15.0;   // moins d'étoiles
uniform float star_size1 = 0.12;      // étoiles plus grosses
uniform float twinkle_intensity1 = 0.6;

// --- Couche 2 (lointaine) ---
uniform float star_density2 = 35.0;   // moins d'étoiles
uniform float star_size2 = 0.06;      // étoiles plus grosses
uniform float twinkle_intensity2 = 0.3;

// Fonction pseudo-aléatoire
float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

// Génération d’une étoile
float star_layer(vec2 uv, float density, float size, float twinkle_intensity) {
    vec2 grid = floor(uv * density);
    vec2 local = fract(uv * density);

    // Décalage aléatoire dans la cellule
    vec2 offset = vec2(rand(grid), rand(grid + 123.0));
    local = fract(local + offset);

    float r = rand(grid);
    float d = distance(local, vec2(0.5));
    float star = smoothstep(size, 0.0, d);
    
    float twinkle = 0.5 + 0.5 * sin(TIME * 8.0 * r * 6.2831);
    star *= mix(1.0, twinkle, twinkle_intensity);
    
    return star;
}

void fragment() {
    vec2 uv = UV * uv_scale;

    float layer1 = star_layer(uv + scroll_speed_layer1 * TIME, star_density1, star_size1, twinkle_intensity1);
    float layer2 = star_layer(uv + scroll_speed_layer2 * TIME, star_density2, star_size2, twinkle_intensity2);

    float star = max(layer1, layer2);

    ALBEDO = vec3(star);
    ALPHA = 1.0;
}
