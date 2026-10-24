extends Node

signal time_changed(hour: int, time_of_day: String)
signal day_changed(day_name: String, day_number: int)
signal season_changed(season: String)

var current_hour: int = 8
var current_day_number: int = 1
var current_season_index: int = 0

var day_names: Array[String] = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
var season_names: Array[String] = ["Spring", "Summer", "Autumn", "Winter"]

var time_speed: float = 1.0
var seconds_per_game_hour: float = 45.0   # Ajusta a tu gusto

var _timer: float = 0.0

func _process(delta: float) -> void:
	_timer += delta * time_speed
	if _timer >= seconds_per_game_hour:
		_timer = 0.0
		_advance_hour()

func _advance_hour() -> void:
	current_hour += 1
	if current_hour >= 24:
		current_hour = 0
		_advance_day()
	time_changed.emit(current_hour, get_time_of_day())

func _advance_day() -> void:
	current_day_number += 1
	
	# Cada 28 días cambia de estación (estilo Stardew)
	if current_day_number % 28 == 1 and current_day_number > 1:
		current_season_index = (current_season_index + 1) % 4
		season_changed.emit(get_season())
	
	day_changed.emit(get_day_name(), current_day_number)

func get_time_of_day() -> String:
	if current_hour >= 6 and current_hour < 12:
		return "morning"
	elif current_hour >= 12 and current_hour < 18:
		return "afternoon"
	elif current_hour >= 18 and current_hour < 22:
		return "evening"
	else:
		return "night"

func get_day_name() -> String:
	return day_names[(current_day_number - 1) % 7]

func get_season() -> String:
	return season_names[current_season_index]

func get_formatted_time() -> String:
	return "%02d:00" % current_hour

func get_full_date_string() -> String:
	return "%s - Day %d - %s" % [get_season(), current_day_number, get_formatted_time()]
