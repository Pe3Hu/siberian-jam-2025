class_name Godray
extends Sprite2D


var maze: Maze
var gatekeeper: Gatekeeper:
	set(value_):
		gatekeeper = value_
		position = gatekeeper.position
		var lock_resource = gatekeeper.obstacle_resource.lock
		var path = lock_resource.resource_path.get_file().trim_suffix('.tres')
		path = path.replace('lock_', "")
		%HelpSprite.texture = load("res://entities/maze/gatekeeper/images/l{path}.png".format({"path":path}))

var is_fact: bool = false:
	set(value_):
		is_fact = value_
		
		%HelpSprite.visible = is_fact


func _on_death_timer_timeout() -> void:
	die()
	
func die() -> void:
	maze.godrays.remove_child(self)
	queue_free()
