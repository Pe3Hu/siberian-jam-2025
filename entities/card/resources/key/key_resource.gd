class_name KeyResource
extends Resource


@export var title: String = ""
@export_enum("звук", "аромат", "прикосновение") var suit: String = "звук"
@export_enum("штраф", "еда", "растение", "акссесуар", "материал", "одежда", "джокер") var type: String = "штраф"


@export var punishments: Array[PunishmentResource]
