extends CharacterBody2D 

@export var speed = 160
@export var jump_velocity = -300 

var dir 
var gravity = 4000 
var jumps = 1

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
	if Input.is_action_just_pressed("Hit1"):
		animator.play('attack1')
		
	if Input.is_action_just_pressed("Hit2"):
		animator.play('attack2')
		
	if Input.is_action_just_pressed("Hit3"):
		animator.play('attack3')
		
	pass
