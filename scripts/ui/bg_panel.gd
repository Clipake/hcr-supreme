@tool
extends PanelContainer


func _on_item_rect_changed() -> void:
	material.set_shader_parameter('aspect_ratio', size.y/size.x)
