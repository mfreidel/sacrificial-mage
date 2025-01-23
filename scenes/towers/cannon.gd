extends TowerNode


@onready var projectile = load("res://scenes/entities/projectile.tscn")
@onready var cball_image = load("res://assets/sprites/cannonball.png")

# Make interaction area accessible here
@onready var interaction_area: InteractionArea = $InteractionArea

# Used for simulating object rotation value, just like in animated_player.gd
var facing_rot = 0

# Used for cycling through the rotation values
var facing_index = 0
var directions_list = [0, 1.5708, 3.14159, -1.5708] # up, right, down, left


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	face_sprite(facing_rot)

# Interaction options for the object
func _on_interact() -> void:
	$CannonMenu.popup()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
## Alters the sprite and collision area of the cannon based on current facing_rot value
func face_sprite(cur_facing_rot) -> void:
	if cur_facing_rot in directions_list: # Only analyze expected values
		if cur_facing_rot == 0: # face up
			$RightColShape.disabled = true
			$LeftColShape.disabled = true
			$VertColShape.disabled = false
			$CannonSprite.frame = 0
		if cur_facing_rot == 1.5708: # face right
			$RightColShape.disabled = false
			$LeftColShape.disabled = true
			$VertColShape.disabled = true
			$CannonSprite.frame = 2
		if cur_facing_rot == -1.5708: # face left
			$RightColShape.disabled = true
			$LeftColShape.disabled = false
			$VertColShape.disabled = true
			$CannonSprite.frame = 3
		if cur_facing_rot == 3.14159: # face down
			$RightColShape.disabled = true
			$LeftColShape.disabled = true
			$VertColShape.disabled = false
			$CannonSprite.frame = 1
	
	


func shoot():
	var instance = projectile.instantiate()
	var vert_offset = Vector2(-8, 0)
	instance.dir = facing_rot
	instance.zdex = z_index - 1
	instance.spawnPos = global_position
	
	if facing_rot == 0:
		instance.spawnPos += vert_offset
	instance.spawnRot = facing_rot
	instance.get_node("ProjectileSprite").texture = cball_image
	instance.get_node("ProjectileSprite").scale = Vector2(1, 1)
	level_node.add_child.call_deferred(instance)


## Unused function.
func _toggle_firing_timer() -> void:
	if $FiringTimer.is_stopped():
		$FiringTimer.start()
		print("cannon.gd -- FiringTimer started.")
	else:
		$FiringTimer.stop()
		print("cannon.gd -- FiringTimer stopped.")

func _on_firing_timer_timeout() -> void:
	shoot()


func _on_cannon_menu_firing_state_toggled(toggled_on: bool) -> void:
	if toggled_on:
		if $FiringTimer.is_stopped():
			$FiringTimer.start()
			print("cannon.gd -- FiringTimer started.")
	else:
		if !($FiringTimer.is_stopped()):
			$FiringTimer.stop()
			print("cannon.gd -- FiringTimer stopped.")


func _on_cannon_menu_rotate_pressed() -> void:
	facing_index += 1
	if facing_index > 3:
		facing_index = 0
	facing_rot = directions_list[facing_index]
	face_sprite(directions_list[facing_index])
	


func _on_cannon_menu_heal_pressed() -> void:
	var heal_cost = 5.0
	var new_health = health + heal_cost
	if new_health > MAX_HEALTH:
		heal_cost = MAX_HEALTH - health # Don't charge more than what gets used.
	heal_from_player(heal_cost)
