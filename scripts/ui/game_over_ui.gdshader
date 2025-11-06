shader_type canvas_item;

uniform float corner_radius: hint_range(0.0, 1.0) = 0.03; // float 0-1 for corner rounding
uniform float aspect_ratio = 1.2; // height/width


bool is_in_circle(float radius, vec2 center, vec2 test_point) {
	// Returns true if test_point falls within the area covered by a circle at (center.x, center.y) with radius radius
	return pow(test_point.x-center.x, 2) + pow(test_point.y-center.y, 2) <= pow(radius, 2);
}


void fragment() {
	// Called for every pixel the material is visible on.
	vec2 corrected_uv = vec2(UV.x, UV.y*aspect_ratio); // UV adjusted for aspect ratio stretching
	
	// TOP-LEFT ROUNDING
	if (!is_in_circle(corner_radius, vec2(corner_radius,corner_radius), corrected_uv)
			&& corrected_uv.x < corner_radius
			&& corrected_uv.y < corner_radius) {
		discard;
	} // TOP-RIGHT ROUNDING
	else if(!is_in_circle(corner_radius, vec2(1.0-corner_radius, corner_radius), corrected_uv)
			&& 1.0-corrected_uv.x < corner_radius
			&& corrected_uv.y < corner_radius) {
		discard;
	} // BOTTOM-RIGHT ROUNDING
	else if(!is_in_circle(corner_radius, vec2(1.0-corner_radius, aspect_ratio-corner_radius), corrected_uv)
			&& 1.0-corrected_uv.x < corner_radius
			&& aspect_ratio-corrected_uv.y < corner_radius) {
		discard;
	} // BOTTOM-LEFT ROUNDING
	else if(!is_in_circle(corner_radius, vec2(corner_radius, aspect_ratio-corner_radius), corrected_uv)
			&& corrected_uv.x < corner_radius
			&& aspect_ratio-corrected_uv.y < corner_radius) {
		discard;
	}
}