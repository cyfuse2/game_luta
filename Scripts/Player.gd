extends CharacterBody2D 

@export var speed = 160
@export var jump_velocity = -300 

var dir 
var gravity = 4000
var jump = 1 

@onready var animator = $AnimSprite 

func _physics_process(delta): 
	
	Move(delta)
	#Animations()
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
		
	
	if is_on_floor():
		jump = 1 
		
	move_and_slide()
	pass 


func Animations():
	
	if velocity.x != 0 and is_on_floor(): 
		animator.play("run") 
		
	elif velocity.x == 0 and is_on_floor(): 
		animator.play('Idle') 
		
		
	if not is_on_floor() and jump > 1: 
		animator.play('Pulo') 
		
	
	if dir > 0: 
		animator.flip_h = false 
		
	elif dir < 0: 
		animator.flip_h = true 
	
	
	
	
	pass 
