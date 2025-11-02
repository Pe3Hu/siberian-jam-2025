extends CardUI



@onready var title_label := %TitleLabel


func set_obstacle_resource(obstacle_resource_: ObstacleResource) -> void:
	obstacle_resource = obstacle_resource_
	title_label.text = obstacle_resource.title
