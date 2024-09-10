extends Area2D
signal collected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var nut_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(nut_types[randi() % nut_types.size()])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_entered(area: Area2D):
	collected.emit()
	queue_free()
