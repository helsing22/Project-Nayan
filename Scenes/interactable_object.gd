extends Area2D

@export var interact_text: String = "Presiona E para interactuar"
@export var one_shot: bool = false          # Si es true, solo se puede usar una vez

var has_been_used: bool = false

func _ready() -> void:
	add_to_group("interactable")

func interact(player: Node) -> void:
	if one_shot and has_been_used:
		player.end_interaction()
		return
	
	print("Interacción realizada con: ", name)
	print(interact_text)
	
	# Aquí más adelante pondremos:
	# - Diálogos
	# - Abrir puertas
	# - Usar máquinas
	# - Recoger objetos
	# - etc.
	
	has_been_used = true
	
	# Importante: siempre avisamos al jugador que terminó la interacción
	player.end_interaction()
