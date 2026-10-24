extends CanvasLayer

@onready var speaker_label: Label = $Panel/VBoxContainer/SpeakerLabel
@onready var dialogue_text: Label = $Panel/VBoxContainer/DialogueText
@onready var choices_container: VBoxContainer = $Panel/VBoxContainer/ChoicesContainer
@onready var choice_buttons: Array[Button] = [
	$Panel/VBoxContainer/ChoicesContainer/ChoiceButton1,
	$Panel/VBoxContainer/ChoicesContainer/ChoiceButton2,
	$Panel/VBoxContainer/ChoicesContainer/ChoiceButton3
]

func _ready() -> void:
	hide_dialogue()
	for i in choice_buttons.size():
		choice_buttons[i].pressed.connect(_on_choice_pressed.bind(i))

func show_dialogue(data: DialogueData) -> void:
	visible = true
	speaker_label.text = data.speaker_name
	dialogue_text.text = data.text
	
	var has_choices := data.choices.size() > 0
	choices_container.visible = has_choices
	
	for i in choice_buttons.size():
		if i < data.choices.size():
			choice_buttons[i].text = data.choices[i]
			choice_buttons[i].visible = true
		else:
			choice_buttons[i].visible = false

func hide_dialogue() -> void:
	visible = false

func _on_choice_pressed(index: int) -> void:
	DialogueManager.select_choice(index)

func _input(event: InputEvent) -> void:
	if not visible:
		return
	if event.is_action_pressed("interact") or event.is_action_pressed("ui_accept"):
		if not choices_container.visible:
			DialogueManager.advance_dialogue()
