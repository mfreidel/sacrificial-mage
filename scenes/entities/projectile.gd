extends CharacterBody2D


@export var SPEED = 420
@export var DAMAGE = 1.0

var dir : float
var spawnPos : Vector2
var spawnRot : float

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot

func _physics_process(_delta):
	velocity = Vector2(0, -SPEED).rotated(dir)
	var collision = move_and_slide()
	if collision:
		var col_target = get_last_slide_collision().get_collider()
		if "damage_health" in col_target:
			col_target.damage_health(DAMAGE)
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
