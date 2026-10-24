extends Label

func _ready() -> void:
	TimeManager.time_changed.connect(_on_time_changed)
	TimeManager.day_changed.connect(_on_day_changed)
	TimeManager.season_changed.connect(_on_season_changed)
	_update_text()

func _on_time_changed(_hour: int, _time_of_day: String) -> void:
	_update_text()

func _on_day_changed(_day_name: String, _day_number: int) -> void:
	_update_text()

func _on_season_changed(_season: String) -> void:
	_update_text()

func _update_text() -> void:
	text = TimeManager.get_full_date_string()
