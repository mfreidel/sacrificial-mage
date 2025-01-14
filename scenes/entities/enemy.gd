extends CharacterBody2D


@export var HEALTH = 5.0
@export var MOVE_SPEED = 1
@export var BASE_DAMAGE = 1.0
@export var PATH_TARGET: Node2D


@onready var nav_agent = $NavigationAgent2D

var can_attack = false
var attack_target : Node2D

func damage_health(damage):
	HEALTH -= damage
	
func body_is_attackable(attack_body):
	var check = false
	if attack_body.get_name() == "AnimatedPlayer":
		check = true
	return check

func makepath() -> void:
	nav_agent.target_position = PATH_TARGET.global_position


func single_attack(attack_body):
	$Attack/AttackAnimation.play("attack_animation")
	if "damage_health" in attack_body:
		attack_body.damage_health(BASE_DAMAGE)
	else:
		# potentially useful debug msg
		print("enemy.gd -- BUGGY CODE! -- Useless attack triggered")

func _physics_process(_delta: float) -> void:
	var direction = nav_agent.get_next_path_position()
	velocity = direction * MOVE_SPEED
	if HEALTH <= 0:
		queue_free()
	move_and_slide()

func _ready() -> void:
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


func _on_path_update_timer_timeout() -> void:
	makepath()
