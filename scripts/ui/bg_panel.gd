@tool
extends PanelContainer


func _on_item_rect_changed() -> void:
	material.set_shader_parameter('aspect_ratio', size.y/size.x)

func _input(e: InputEvent) -> void:
	if e is InputEventMouseMotion:
		var local_position: Vector2 = e.position - get_global_transform().origin
		var center: Vector2 = self.size/2.0
		
		var intersections: Array = get_intersections(local_position, center)

		var gradient: GradientTexture2D = get_theme_stylebox('panel').texture
		gradient.fill_from = intersections[0]
		gradient.fill_to = intersections[1]


func get_line(from: Vector2, to: Vector2) -> Array[Callable]:
	var m: float = INF if to.x==from.x else (to.y-from.y)/(to.x-from.x)
	var b: float = to.y-(to.x*m)
	
	var terms_of_x = func(x: float):
		return (m*x)+b
	var terms_of_y = func(y: float):
		return (y-b)/m
		
	return [terms_of_x, terms_of_y]

func get_intersections(from: Vector2, to: Vector2) -> Array:
	var result = []
	var intersection: Vector2 = Vector2.ZERO
	var intersection2: Vector2 = Vector2.ZERO
	
	var line: Callable = get_line(from, to)[0]
	var line2: Callable = get_line(from, to)[1]
	
	# Test for undefined line
	if !is_finite(line.call(0)) and !is_finite(line2.call(0)):
		if to.y > from.y:
			return [Vector2(0.5, 0), Vector2(0.5, 1)]
		else:
			return [Vector2(0.5, 1), Vector2(0.5, 0)]
			
	# Line at left bound is within left bound
	if line.call(0) <= size.y and line.call(0) >= 0:
		intersection = Vector2(0.0, line.call(0)/size.y)
	# Line at right bound is within right bound
	if line.call(size.x) <= size.y and line.call(size.x) >= 0:
		intersection2 = Vector2(1.0, line.call(size.x)/size.y)
	# Line at top bound is within bottom bound
	if line2.call(0) <= size.x and line2.call(0) >= 0:
		intersection = Vector2(line2.call(0)/size.x, 0.0)
	# Line at bottom bound is within top bound
	if line2.call(size.y) <= size.x and line2.call(size.y) >= 0:
		intersection2 = Vector2(line2.call(size.y)/size.x, 1.0)
		
	if (to.x > from.x and intersection2.x > intersection.x) \
			or (to.y > from.y and intersection2.y > intersection.y):
		result.append(intersection)
		result.append(intersection2)
	else:
		result.append(intersection2)
		result.append(intersection)
	
	return result
