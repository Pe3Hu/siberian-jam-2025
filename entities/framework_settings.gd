extends Node


const ranks = ["2","3","4","5","6","7","8","9","10","J","Q","K","A"]

const KEY_IN_HAND_LIMIT: int = 2
const HAND_LIMIT: int = 10
const HAND_DEFAULT: int = 7

var current_obstacle_index: int = 0

var key_in_hand: Dictionary
var key_exceptions: Array[KeyResource]
