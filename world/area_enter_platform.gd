@tool
extends Platform_v1

func _on_area_3d_body_entered(body: DynamicSoul) -> void:
	move_platform()
