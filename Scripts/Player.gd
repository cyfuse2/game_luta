extends CharacterBody2D 

@export var speed = 130
@export var jump_velocity = -300.0
@export var max_health: int
@export var health = 0 : set = _set_health
@export var ataque = 5
@onready var bar_1 = $ProgressBar
@onready var timer 
@onready var timer_attack: Timer = $Timer_Attack
@onready var delay_attack: Timer = $Delay_Attack

var dir 
var gravity = 6000
var pode_atacar = true
var attack_index = 0
var is_attacking = false
var life = 2

func _set_health(new_health):
	if new_health <= 0:
		queue_free()
		return
	if new_health >= max_health:
		new_health = max_health
		
	if new_health >= health:
		health = new_health
		bar_1.value = health
	else:
		health = new_health
		
		bar_1.value = health
		timer.start(0.5)
	pass
	

@onready var animator = $AnimSprite

func _physics_process(delta):
	Move(delta)
	Animations()
	Attack()
	pass 
	
	
func Move(delta): 
	dir = Input.get_axis("Esquerda" , "Direita") 
	
	
	if dir: 
		velocity.x = dir * speed 
	else: 
		velocity.x = 0  
		
	if not is_on_floor(): 
		velocity.y += gravity * delta 
		
	if Input.is_action_just_pressed("Pulo") and is_on_floor(): 
		velocity.y += jump_velocity
		
	move_and_slide()
	pass 


func Animations():
	if pode_atacar:
		if velocity.x != 0 and is_on_floor(): 
			animator.play("walk")
		elif velocity.x == 0 and is_on_floor(): 
			animator.play("idle")
	if not is_on_floor(): 
		if pode_atacar:
			animator.play("jump")
	pass
	
func Attack():
	if pode_atacar and Input.is_action_just_pressed("Ataque1"):
		if animator.animation != "attack1":
		# Inicia a animação de ataque
			animator.play("attack1")
		# Controla a lógica de ataque (tempo entre ataques)
		pode_atacar = false
		$Timer_Attack.wait_time = 0.8
		timer_attack.start()  # Inicia o temporizador do ataque
		
		attack_index += 1
		print(attack_index)
		$HitBox/Hit1.disabled = false
		if attack_index >= 3:
			# Se o personagem atingir o número máximo de ataques consecutivos, aguarda antes de poder atacar novamente
			delay_attack.start()
			
	if pode_atacar and Input.is_action_just_pressed("Ataque2"):
		if animator.animation != "attack2":
		# Inicia a animação de ataque
			animator.play("attack2")
		# Controla a lógica de ataque (tempo entre ataques)
		pode_atacar = false
		$Timer_Attack.wait_time = 0.8
		timer_attack.start()  # Inicia o temporizador do ataque
		
		attack_index += 1
		print(attack_index)
		$HitBox/Hit2.disabled = false
		if attack_index >= 3:
			delay_attack.start()
			
	if pode_atacar and Input.is_action_just_pressed("Ataque3"):
		if animator.animation != "attack3":
			animator.play("attack3")
		pode_atacar = false
		$Timer_Attack.wait_time = 0.8
		timer_attack.start()
		
		attack_index += 1
		print(attack_index)
		$HitBox/Hit3.disabled = false
		if attack_index >= 3:
			delay_attack.start()
			
	pass
	
func  Hit():
	animator.play("Attack1")
	life -= 5
	await get_tree().create_timer(0.4).timeout
	animator.play("idle")
	pass
	

func _on_timer_attack_timeout():
	pode_atacar = true
	animator.play("idle")
	$HitBox/Hit1.disabled = true
	$HitBox/Hit2.disabled = true 
	$HitBox/Hit3.disabled = true
	pass


func _on_delay_attack_timeout():
	attack_index = 0
	pode_atacar = true
	pass


func _on_hit_box_body_entered(body):
	if body.is_in_group("Players"):
		body.Hit()
	pass # Replace with function body.

#
#func _on_anim_sprite_animation_finished(anim_name):
	#if anim_name == "attack1":
		## A animação terminou, volta para idle
		#animator.play("idle")
		## Desmarca o ataque
		#is_attacking = false
		#
	#if anim_name == "attack2":
		## A animação terminou, volta para idle
		#animator.play("idle")
		## Desmarca o ataque
		#is_attacking = false
	#pass
