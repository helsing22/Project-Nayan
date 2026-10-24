class_name DialogueEntry
extends Resource

@export var dialogue: DialogueData

# Condiciones
@export var min_relationship: int = 0
@export var max_relationship: int = 999
@export var allowed_times: Array[String] = []     # "morning", "afternoon", "evening", "night" — vacío = cualquier hora
@export var allowed_days: Array[String] = []      # "monday", "tuesday"... — vacío = cualquier día
@export var required_flags: Array[String] = []
@export var priority: int = 0                     # Más alto = más prioritario

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
