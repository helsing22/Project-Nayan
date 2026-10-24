extends Node

signal dialogue_started
signal dialogue_finished
signal choice_selected(choice_index: int)

var is_active: bool = false
var current_dialogue: DialogueData = null
var dialogue_ui: CanvasLayer = null

func _ready() -> void:
	dialogue_ui = get_tree().get_first_node_in_group("dialogue_ui")

func start_dialogue(dialogue: DialogueData) -> void:
	if is_active or dialogue == null:
		return
	
	is_active = true
	current_dialogue = dialogue
	dialogue_started.emit()
	
	if dialogue_ui and dialogue_ui.has_method("show_dialogue"):
		dialogue_ui.show_dialogue(dialogue)

func advance_dialogue() -> void:
	end_dialogue()

func select_choice(index: int) -> void:
	choice_selected.emit(index)
	end_dialogue()

func end_dialogue() -> void:
	is_active = false
	current_dialogue = null
	dialogue_finished.emit()
	
	if dialogue_ui and dialogue_ui.has_method("hide_dialogue"):
		dialogue_ui.hide_dialogue()
