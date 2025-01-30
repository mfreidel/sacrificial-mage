extends CanvasLayer
## Base-level script for PlayerHUD Node.

# Labels in scene tree to update
@onready var health_status_label = $HealthContainer/HealthStatus
@onready var max_health_status_label = $HealthContainer/MaxHealthStatus
@onready var wave_count_label = $WaveCount

# Images in scene tree to update
@onready var weapon_image = $WeaponImage
@onready var build_image = $BuildImage

# Load weapon images
@onready var res_sword_img = load("res://assets/ui_images/long_sword1.png")
@onready var res_fball_img = load("res://assets/sprites/fire_ball.png")

# Load structure images
@onready var res_cannon_img = load("res://assets/ui_images/cannon_single.png")
@onready var res_statue_img = load("res://assets/sprites/statue.png")

# Nodes from scene tree
@onready var player_node = get_tree().get_first_node_in_group("player")
@onready var level_node = get_tree().get_root().get_node("Level")


# built-in, runs when node enters scene tree
func _ready() -> void:
	$GameOverPanel.visible = false
	$GameOverPanel.process_mode = Node.PROCESS_MODE_WHEN_PAUSED

# built-in, runs every frame
func _process(_delta: float) -> void:
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


## The score label gets updated via a ScoreController 'score_increased' signal
## which is attached to animated_player.gd
func _update_score_label(new_score:int):

	$StatsRegion/ScoreContainer/ScoreStatus.text = str(new_score)


func update_labels() -> void:
	var player_health = get_player_health()
	var player_max_health = get_player_max_health()
	var wave_count = level_node.get_wave_number()
	health_status_label.text = str(player_health)
	max_health_status_label.text = str(player_max_health)
	wave_count_label.text = str(wave_count)


func update_images() -> void:
	var selected_weapon = get_player_selected_weapon()
	var selected_tower = get_player_selected_tower()
	# Weapon Images
	if selected_weapon == "melee":
		weapon_image.texture = res_sword_img
	elif selected_weapon == "fireball":
		weapon_image.texture = res_fball_img
	else:
		print("player_hud.gd -- Invalid weapon selection: " + str(selected_weapon))
	
	# Tower Images
	if selected_tower == "cannon":
		build_image.texture = res_cannon_img
	elif selected_tower == "statue":
		build_image.texture = res_statue_img
	else:
		print("player_hud.gd -- Invalid tower selection: " + str(selected_tower))


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	$GameOverPanel.visible = false
	level_node.restart_level()
	


func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/start_menu/start_menu.tscn")




func _on_player_death() -> void:
	get_tree().paused = true
	$GameOverPanel/VBoxContainer/HBoxContainer/FinalScore.text = str(level_node._get_current_score())
	$GameOverPanel.visible = true
