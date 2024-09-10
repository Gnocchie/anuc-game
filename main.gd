extends Node

@export var mob_scene: PackedScene
@export var nut_scene: PackedScene
var score = 0
var hard_mode = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/AnimatedSprite2D.play()
	$Music.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	pass

func game_over():
	$DeathSound.play()
	$mobTimer.stop()
	get_tree().call_group("nuts", "queue_free")
	if hard_mode:
		$HUD.show_game_over("WOMP WOMP")
	else:
		$HUD.show_game_over("Nuts Burnt :(")

func new_game():
	get_tree().call_group("mobs", "queue_free")
	
	score = 0
	$player.start($startPosition.position)
	$startTimer.start()
	
	$HUD.update_score(score)
	if hard_mode:
		$HUD.show_message("Entering Hell...")
	else:
		$HUD.show_message("Get Ready")

func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $mobPath/mobSpawner
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(200.0, 350.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

func _on_hud_easy_mode() -> void:
	hard_mode = false
	$CanvasLayer/ColorRect.set_color("#631825")
	$Music_HARD.stop()
	$Music.play()
	$player/AnimatedSprite2D.set_speed_scale(2)

	
func _on_hud_hard_mode() -> void:
	hard_mode = true
	$CanvasLayer/ColorRect.set_color("black")
	$Music.stop()
	$Music_HARD.play()
	$CanvasLayer/AnimatedSprite2D.set_speed_scale(15)
	

func _on_start_timer_timeout():
	if hard_mode:
		$mobTimer.set_wait_time(0.25)
	$mobTimer.start()
	nutify()
	
func nut_collect():
	score += 1
	$nutNoise.play()
	$HUD.update_score(score)
	nutify()

func nutify():
	var nut = nut_scene.instantiate()
	var nut_position = Vector2(randi_range(100,620),randi_range(100,620))
	nut.position = nut_position
	add_child(nut)
	nut.connect("collected", Callable(self, "nut_collect"))
