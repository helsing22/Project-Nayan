class_name DialogueData
extends Resource

@export var dialogue_id: String = ""
@export var speaker_name: String = ""
@export_multiline var text: String = ""
@export var choices: Array[String] = []          # Vacío = solo continuar
@export var next_ids: Array[String] = []         # Para cadenas futuras
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
