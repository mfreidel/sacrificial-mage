extends TowerNode

# A nested dictionary structure hold upgrade details.
var upgrades_table : Dictionary = {
	"auto_fire": {
		"text": "Automatic firing",
		"upgrade_cost": 15.0,
		"is_applied": false
	},
	"increase_damage": {
		"text": "Increase cannon damage",
		"upgrade_cost": 10.0,
		"is_applied": false
	}
}

var damage = 2
var auto_fire_enabled = false

@onready var projectile = preload("res://scenes/entities/projectile.tscn")
@onready var cball_image = preload("res://assets/sprites/cannonball.png")

# Make interaction area accessible here
@onready var interaction_area: InteractionArea = $InteractionArea

# Use default build cost from TowerNode class
var BUILD_COST = DEFAULT_BUILD_COST

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
	instance.DAMAGE = damage
	if (facing_rot == 0) or (facing_rot == 3.14159):
		instance.spawnPos += vert_offset
	instance.spawnRot = facing_rot
	instance.get_node("ProjectileSprite").texture = cball_image
	instance.get_node("ProjectileSprite").scale = Vector2(1, 1)
	level_node.add_child.call_deferred(instance)


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

func _on_cannon_menu_fire_pressed() -> void:
	shoot()

func _on_cannon_menu_destroy_pressed() -> void:
	player_node.increase_health(health)
	queue_free()
	print("cannon.gd -- cannon destroyed on button press")

func _on_upgrade_menu_apply_upgrades(names_list: Array) -> void:
	for upgrade_name in names_list:
		var record = $UpgradeManager.get_upgrade_record(upgrade_name)
		if upgrade_name == "increase_damage":
			if player_node.apply_spell_damage(record["upgrade_cost"]):
				damage += 1
				$UpgradeManager.set_upgrade_is_applied(upgrade_name)
		elif upgrade_name == "auto_fire":
			if player_node.apply_spell_damage(record["upgrade_cost"]):
				auto_fire_enabled = true
				$UpgradeManager.set_upgrade_is_applied(upgrade_name)


func _on_cannon_menu_upgrade_pressed() -> void:
	$CannonMenu.hide()
	$UpgradeMenu.popup()
