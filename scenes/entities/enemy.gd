extends CharacterBody2D


@export var HEALTH = 5.0
@export var BASE_DAMAGE = 1.0

func damage_health(damage):
	HEALTH -= damage

func _physics_process(_delta):
	if HEALTH <= 0:
		queue_free() 


func _on_attack_body_entered(body: Node2D) -> void:
	if body.get_name() == "AnimatedPlayer":
		#print(body)
		$Attack/AttackAnimation.play("attack_animation")
		body.damage_health(BASE_DAMAGE)
		
