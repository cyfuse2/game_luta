extends CharacterBody2D 

@export var speed = 130
@export var jump_velocity = -500 
@export var max_health: int
@export var health = 0 : set = _set_health

@onready var bar_1 = $ProgressBar
@onready var timer = $Timer
@onready var timer_attack: Timer = $Timer_Attack
@onready var delay_attack: Timer = $Delay_Attack

var dir 
var gravity = 6000 
var jumps = 1
var pode_atacar = true
var attack_index = 0


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
		velocity.y =+ gravity * delta 
		
	if Input.is_action_just_pressed("Pulo") and is_on_floor(): 
		velocity.y = jump_velocity
		
	move_and_slide()
	pass 


func Animations():
	if velocity.x != 0 and is_on_floor(): 
		animator.play("walk")
		
	elif velocity.x == 0 and is_on_floor(): 
		animator.play('idle')
		
	if not is_on_floor(): 
		animator.play('jump')
	pass
	
func Attack():
	if pode_atacar:
		timer_attack.start()
		attack_index += 1
	if attack_index >= 3:
		pode_atacar = false
		delay_attack.start()
	pass
	

func _on_timer_attack_timeout():
	attack_index = 0
	pass


func _on_delay_attack_timeout():
	pode_atacar = true
	pass
