extends Node

var last_position := Vector2.ZERO
var enemy_last_positions : Dictionary = {}
var StartFromSave := true
var player_level_stats := []
var used_triggers: Array = []
var triggered_story_events: Array = []


func _ready() -> void:
	checkCompletedEvents()

func checkCompletedEvents():
	if triggered_story_events.size() == 0:
		StartFromSave = false
		last_position = Vector2(0,0)
		
