extends CharacterBody2D

@export var npc_name: String = "NPC"
@export var dialogue_set: NPCDialogueSet
@export var relationship_level: int = 0

func _ready() -> void:
	add_to_group("interactable")
	add_to_group("npc")

func interact(player: Node) -> void:
	var dialogue := get_current_dialogue()
	
	if dialogue == null:
		player.end_interaction()
		return
	
	DialogueManager.start_dialogue(dialogue)
	
	if not DialogueManager.dialogue_finished.is_connected(_on_dialogue_finished.bind(player)):
		DialogueManager.dialogue_finished.connect(_on_dialogue_finished.bind(player), CONNECT_ONE_SHOT)

func get_current_dialogue() -> DialogueData:
	if dialogue_set == null:
		return null
	
	var current_time := TimeManager.get_time_of_day()
	var current_day := TimeManager.get_day_name()
	
	var valid_entries: Array[DialogueEntry] = []
	
	for entry in dialogue_set.entries:
		if _meets_conditions(entry, current_time, current_day):
			valid_entries.append(entry)
	
	if valid_entries.is_empty():
		if relationship_level < 0 and dialogue_set.low_relationship_dialogue:
			return dialogue_set.low_relationship_dialogue
		if dialogue_set.busy_dialogue:
			return dialogue_set.busy_dialogue
		return dialogue_set.default_fallback
	
	valid_entries.sort_custom(func(a, b): return a.priority > b.priority)
	return valid_entries[0].dialogue

func _meets_conditions(entry: DialogueEntry, time: String, day: String) -> bool:
	if relationship_level < entry.min_relationship or relationship_level > entry.max_relationship:
		return false
	if entry.allowed_times.size() > 0 and time not in entry.allowed_times:
		return false
	if entry.allowed_days.size() > 0 and day not in entry.allowed_days:
		return false
	return true

func _on_dialogue_finished(player: Node) -> void:
	player.end_interaction()
