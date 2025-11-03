extends Node



var is_flash: bool = false
var is_blackjack: bool = false
var is_street: bool = false


var visited_locks: Array[ObstacleResource]
var key_input_lock: Dictionary
var key_output_lock: Dictionary
var key_ignore_lock: Dictionary
