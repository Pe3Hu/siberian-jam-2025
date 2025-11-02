class_name Bank
extends PanelContainer

const core_types = ["action", "credit", "health", "armor"]

@export var board: Board

@onready var action_token: Token = %ActionToken
@onready var credit_token: Token = %CreditToken
@onready var armor_token: Token = %ArmorToken
@onready var health_token: Token = %HealthToken
@onready var damage_tokens: HBoxContainer = %DamageTokens



func apply_effect(effect_resource_: EffectResource) -> void:
	pass
