class_name Bank
extends PanelContainer



@export var board: Board

@onready var silent_token = %SilentToken
@onready var pulse_timer = %PulseTimer
@onready var pulse_texture = %PulseTexture


var is_short: bool = false


func short_pulse() -> void:
	is_short = true
	pulse_timer.wait_time = 1.5
	


func _ready() -> void:
	reset()
	
func reset() -> void:
	silent_token.value_int = Settings.DEFAULT_SILENT_VALUE
	
func update_token(suit_: String, value_: int) -> void:
	#return
	match suit_:
		"звук":
			start_pulse()
			silent_token.value_int += value_
			
			if silent_token.value_int < 1:
				board.world.show_end_game()


func start_pulse() -> void:
	if !pulse_texture.visible:
		pulse_texture.visible = true
		pulse_timer.start()

func _on_pulse_timer_timeout() -> void:
	pulse_texture.visible = false
	
	if is_short:
		is_short = false
		pulse_timer.wait_time = 4.5
