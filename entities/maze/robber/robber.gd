class_name Robber
extends CharacterBody2D



#@export var resource: UnitResource
@export var maze: Maze
@export var sprite_size: Vector2i = Vector2i(16, 16)

var is_jumping: bool = false
var target_mouse_postion: Vector2

var target_milestones: Array[Vector2]
var exit_position: Vector2


enum State{IDLE, FOLLOW}
var current_state: State = State.IDLE:
	set(value_):
		current_state = value_
		
		if current_state == State.IDLE:
			$IdleTimer.start()

@onready var animations: AnimationPlayer = $AnimationPlayer
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D


func update_animation() -> void:
	if maze.on_pause: 
		if animations.is_playing():
			animations.stop()
		return
	
	if velocity.length() == 0:
		#Disabling animation in case of inactivity
		if animations.is_playing():
			animations.stop()
	else:
		#Determining the direction of movement
		var angle = velocity.angle()
		
		if angle < 0:
			angle += PI * 2
		
		var direction = "Right"
		
		if angle >= PI/4 and angle < PI*3/4: direction = "Down"
		elif angle >= PI*3/4 and angle < PI*5/4: direction = "Left"
		elif angle >= PI*5/4 and angle < PI*7/4: direction = "Up"
		animations.play("walk" + direction)



func _ready() -> void:
	#$BodySprite.texture = load("res://assets/images/sprites/robber/" + str(resource.face_index) + ".png")
	pass
	
func _physics_process(_delta: float) -> void:
	if maze.on_pause: 
		update_animation()
		return
	
	update_velocity() 
	move_and_slide()
	
	#Animate movement
	if current_state != State.IDLE:
		update_animation()
	else:
		if animations.is_playing():
			animations.stop()
	
func update_velocity() -> void:
	var current_agent_position = global_position
	
	match current_state:
		#stop movement in case IDLE state
		State.IDLE:
			velocity = Vector2.ZERO
			return
		#Player stalking
		State.FOLLOW:
			#Choosing player position for movement
			nav_agent.target_position = target_mouse_postion
	
	var next_path_position = nav_agent.get_next_path_position()
	var speed = Settings.robber_speed
	if maze.on_exit:
		speed = Settings.robber_exit_speed
		
	var new_velocity = current_agent_position.direction_to(next_path_position) * speed
	
	#Status change at the end of movement
	if nav_agent.is_navigation_finished():
		current_state = State.IDLE
		$NavigationAgent2D.avoidance_enabled = false
		$CollisionShape2D.disabled = true
		
		if maze.on_exit:
			maze.game_over()
		return
	
	#Applying velocity
	if nav_agent.avoidance_enabled:
		nav_agent.set_velocity(new_velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(new_velocity)
	
func follow_gatekeeper() -> void:
	nav_agent.target_position = target_mouse_postion
	current_state = State.FOLLOW
	
func _on_navigation_agent_2d_velocity_computed(safe_velocity_: Vector2) -> void:
	velocity = safe_velocity_
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		if maze.on_exit: return
		if !maze.on_focus: return
		if maze.on_pause: return
		target_mouse_postion = get_global_mouse_position()
		current_state = State.FOLLOW
	
func _on_gatekeeper_area_area_entered(area: Area2D) -> void:
	if area is Gatekeeper:
		area.bite()
