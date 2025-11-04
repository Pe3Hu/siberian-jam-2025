class_name Gatekeeper
extends Area2D


@export var maze: Maze
@onready var animation_player = %AnimationPlayer
@onready var shadow_sprite = %ShadowSprite
@onready var body_sprite = %BodySprite

var coord: Vector2i

var obstacle_resource: ObstacleResource
var godray: Godray


func _ready() -> void:
	%ShadowSprite.visible = Settings.on_test

func bite() -> void:
	maze.robber.target_mouse_postion = maze.robber.global_position
	maze.robber.current_state = maze.robber.State.IDLE
	maze.on_pause = true
	%ShadowSprite.visible = true
	maze.open_tile(position)
	maze.current_gatekeeper = self
	maze.world.board.update_gatekeeper()
	animation_player.play("bite")
	await animation_player.animation_finished
	#die()
	
func die() -> void:
	maze.coord_to_gatekeepers.erase(coord)
	maze.gatekeepers_skulls += 1
	burn()

func burn() -> void:
	shadow_sprite.texture = null
	#shadow_sprite.material = ShaderMaterial.new()
	body_sprite.material = ShaderMaterial.new()
	#shadow_sprite.material.shader = load("res://entities/maze/gatekeeper/dissolve.gdshader")
	body_sprite.material.shader = load("res://entities/maze/gatekeeper/dissolve.gdshader")
	var noise = NoiseTexture2D.new()
	noise.width = 16
	noise.height = 16
	noise.noise = FastNoiseLite.new()
	noise.noise.frequency = 1
	#shadow_sprite.material.set_shader_parameter("noise", noise)
	body_sprite.material.set_shader_parameter("noise", noise)
	
	if body_sprite.material and body_sprite.material is ShaderMaterial:
		var direction = randf_range(0.0, 360.0)
		var tween = create_tween()
		# set burning direction in degrees
		#shadow_sprite.material.set_shader_parameter("direction", direction)
		body_sprite.material.set_shader_parameter("direction", direction)
		# use tweens to animate the progress value
		tween.tween_method(update_progress, -1.5, 1.5, Settings.GATEKEEPER_DISSOLVE_TIME)
		tween.tween_callback(byebye)
	
func update_progress(value: float):
	if body_sprite.material:
		#shadow_sprite.material.set_shader_parameter("progress", value)
		body_sprite.material.set_shader_parameter("progress", value)
	
func byebye() -> void:
	#maze.on_pause = false
	maze.gatekeepers.remove_child(self)
	queue_free()
	
