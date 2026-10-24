class_name NPCDialogueSet
extends Resource

@export var entries: Array[DialogueEntry] = []

@export var busy_dialogue: DialogueData = null
@export var low_relationship_dialogue: DialogueData = null
@export var default_fallback: DialogueData = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
