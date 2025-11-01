shader_type canvas_item;

uniform float corner_radius = 46; // better if even

bool is_in_circle(float radius, vec2 center, vec2 test_point) {
	return pow(test_point.x-center.x, corner_radius) + pow(test_point.y-center.y, corner_radius) >= pow(radius, corner_radius);
}

//float circle(int radius, vec2 center, float x) {
	//// (x-center.x)^2+(y-center.y)^2=radius^2
	//// 
//}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	if (is_in_circle(0.5, vec2(0.5,0.5), UV)) {
		discard;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
