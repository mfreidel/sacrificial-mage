extends CharacterBody2D


@export var HEALTH = 5.0
@export var MOVE_SPEED = 25.0
@export var BASE_DAMAGE = 1.0
@export var PATH_TARGET: Node2D

#@onready var level_node = get_tree().get_root().get_node("Level")
@onready var nav_agent = $NavigationAgent2D
@onready var next_agent_path_pos

var can_attack = false
var attack_target : Node2D

func damage_health(damage):
	HEALTH -= damage
	
func face_left() -> void:
	$EnemySprite.flip_h = true
	$Attack/AttackSprite.flip_h = true
	$Attack/AttackShapeRight.disabled = true
	$Attack/AttackShapeLeft.disabled = false

func face_right() -> void:
	$EnemySprite.flip_h = false
	$Attack/AttackSprite.flip_h = false
	$Attack/AttackShapeRight.disabled = false
	$Attack/AttackShapeLeft.disabled = true
	
func body_is_attackable(attack_body):
	var check = false
	if attack_body.get_name() == "AnimatedPlayer":
		check = true
	if attack_body is TowerNode:
		check = true
	return check

func makepath() -> void:
	nav_agent.target_position = PATH_TARGET.global_position

func path_setup():
	await get_tree().physics_frame
	if PATH_TARGET:
		makepath()

func single_attack(attack_body):
	$Attack/AttackAnimation.play("attack_animation")
	if "damage_health" in attack_body:
		attack_body.damage_health(BASE_DAMAGE)
	else:
		# potentially useful debug msg
		print("enemy.gd -- BUGGY CODE! -- Useless attack triggered")

func _physics_process(_delta) -> void:
	if HEALTH <= 0:
		queue_free()
	if PATH_TARGET && next_agent_path_pos:
		var current_agent_pos = global_position
		var move_direction = current_agent_pos.direction_to(next_agent_path_pos)
		velocity = move_direction * MOVE_SPEED
		if move_direction.x < 0:
			face_left()
		if move_direction.x > 0:
			face_right()
	move_and_slide()

func _ready() -> void:
	face_right()
	call_deferred("path_setup")
	if !($AttackTimer.is_stopped()):
			$AttackTimer.stop()


func _on_attack_body_entered(body: Node2D) -> void:
	if body_is_attackable(body):
		can_attack = true
		attack_target = body
		if $AttackTimer.is_stopped():
			$AttackTimer.start()


func _on_attack_body_exited(body: Node2D) -> void:
	if body_is_attackable(body):
		can_attack = false
		if !($AttackTimer.is_stopped()):
			$AttackTimer.stop()



func _on_attack_timer_timeout() -> void:
	print("Enemy AttackTimer timeout triggered -- attacking target: " + str(attack_target))
	if can_attack:
		single_attack(attack_target)
	else:
		$AttackTimer.stop()


func _on_path_refresh_timeout() -> void:
	makepath()
	next_agent_path_pos = nav_agent.get_next_path_position()
