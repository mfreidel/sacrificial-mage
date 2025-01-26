extends CanvasLayer
## Base-level script for PlayerHUD Node.

# Load weapon images
@onready var res_sword_img = load("res://assets/ui_images/long_sword1.png")
@onready var res_arrow_img = load("res://assets/sprites/arrow.png")

# Load structure images
@onready var res_cannon_img = load("res://assets/ui_images/cannon_single.png")
@onready var res_statue_img = load("res://assets/sprites/statue.png")

# Player node
@onready var player_node = get_tree().get_first_node_in_group("player")

# built-in, runs when node enters scene tree
func _ready() -> void:
	pass

# built-in, runs every frame
func _process(delta: float) -> void:
	update_images()
	update_labels()


func get_player_health():
	return player_node.health


func get_player_max_health():
	return player_node.MAX_HEALTH


func get_player_selected_tower():
	var selection = player_node.selected_tower
	var list = player_node.towers_list
	return list[selection]


func get_player_selected_weapon():
	var selection = player_node.player_weapon
	var list = player_node.weapons_list
	return list[selection]


func get_player_score():
	pass

func update_labels() -> void:
	var player_health = get_player_health()
	var player_max_health = get_player_max_health()
	$MainPanel/MainContainer/HealthContainer/HealthStatus.text = str(player_health)
	$MainPanel/MainContainer/HealthContainer/MaxHealthStatus.text = str(player_max_health)


func update_images() -> void:
	var selected_weapon = get_player_selected_weapon()
	var selected_tower = get_player_selected_tower()
	
	if selected_weapon == "melee":
		$MainPanel/MainContainer/WeaponImage.texture = res_sword_img
	elif selected_weapon == "ranged":
		$MainPanel/MainContainer/WeaponImage.texture = res_arrow_img
	else:
		print("player_hud.gd -- Invalid weapon selection: " + str(selected_weapon))

	if selected_tower == "cannon":
		$MainPanel/MainContainer/BuildImage.texture = res_cannon_img
	elif selected_tower == "statue":
		$MainPanel/MainContainer/BuildImage.texture = res_statue_img
	else:
		print("player_hud.gd -- Invalid tower selection: " + str(selected_tower))
