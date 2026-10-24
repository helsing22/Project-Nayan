extends CharacterBody2D

# --- Exportaciones ---
@export var walk_speed: float = 100.0
@export var run_speed: float = 180.0
@export var acceleration: float = 1200.0
@export var friction: float = 1400.0

@export var max_stamina: float = 50.0
@export var stamina_drain_rate: float = 25.0    
@export var stamina_regen_rate: float = 9.0   
@export var min_stamina_to_run: float = 2.5  

# --- Estados ---
enum State { IDLE, WALK, INTERACTING }
var current_state: State = State.IDLE

# --- Variables ---
var facing_direction: Vector2 = Vector2.DOWN
var interactables_in_range: Array[Node] = []
var current_interactable: Node = null

var current_stamina: float = 100.0
var is_running: bool = false

# --- Referencias ---
@onready var stamina_bar: ProgressBar = get_tree().get_first_node_in_group("stamina_bar")
@onready var sprite: Sprite2D = $Sprite2D
@onready var interaction_area: Area2D = $InteractionArea
@onready var interact_prompt: Label = get_tree().get_first_node_in_group("interact_prompt")

func _ready() -> void:
	current_stamina = max_stamina
	interaction_area.body_entered.connect(_on_interaction_area_body_entered)
	interaction_area.body_exited.connect(_on_interaction_area_body_exited)
	interaction_area.area_entered.connect(_on_interaction_area_area_entered)
	interaction_area.area_exited.connect(_on_interaction_area_area_exited)

func _physics_process(delta: float) -> void:
	match current_state:
		State.IDLE, State.WALK:
			handle_stamina(delta)
			handle_movement(delta)
			handle_interaction_input()
			update_state()
			update_interact_prompt()
		State.INTERACTING:
			velocity = Vector2.ZERO
			move_and_slide()
			if interact_prompt:
				interact_prompt.visible = false

func handle_stamina(delta: float) -> void:
	var wants_to_run := Input.is_action_pressed("run")
	
	if wants_to_run and current_stamina > min_stamina_to_run and velocity.length() > 10.0:
		is_running = true
		current_stamina = max(current_stamina - stamina_drain_rate * delta, 0.0)
	else:
		is_running = false
		current_stamina = min(current_stamina + stamina_regen_rate * delta, max_stamina)
	
	# Actualizar la barra de estamina
	if stamina_bar:
		stamina_bar.value = current_stamina
		
		# Cambio de color según la cantidad de estamina
		if current_stamina > 60:
			stamina_bar.modulate = Color(0.3, 0.9, 0.4)		# Verde
		elif current_stamina > 30:
			stamina_bar.modulate = Color(0.95, 0.85, 0.2)	# Amarillo
		else:
			stamina_bar.modulate = Color(0.95, 0.3, 0.3)		# Rojo

func handle_movement(delta: float) -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	var current_speed := run_speed if is_running else walk_speed
	
	if input_vector != Vector2.ZERO:
		facing_direction = input_vector.normalized()
		velocity = velocity.move_toward(input_vector * current_speed, acceleration * delta)
		update_sprite_direction()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	move_and_slide()

func update_sprite_direction() -> void:
	if abs(facing_direction.x) > abs(facing_direction.y):
		sprite.flip_h = facing_direction.x < 0
	else:
		sprite.flip_h = false

#STATE MACHINE

func update_state() -> void:
	if velocity.length() > 5.0:
		change_state(State.WALK)
	else:
		change_state(State.IDLE)

func update_interact_prompt() -> void:
	if interact_prompt == null:
		return
	
	var nearest = get_nearest_interactable()
	
	if nearest != null:
		interact_prompt.visible = true
	else:
		interact_prompt.visible = false

func change_state(new_state: State) -> void:
	if current_state == new_state:
		return
	
	current_state = new_state
	
	match current_state:
		State.INTERACTING:
			velocity = Vector2.ZERO
			is_running = false

# INTERACIONES

func handle_interaction_input() -> void:
	if Input.is_action_just_pressed("interact"):
		try_interact()

func try_interact() -> void:
	current_interactable = get_nearest_interactable()
	
	if current_interactable and current_interactable.has_method("interact"):
		change_state(State.INTERACTING)
		current_interactable.interact(self)

func get_nearest_interactable() -> Node:
	if interactables_in_range.is_empty():
		return null
	
	var nearest: Node = null
	var min_distance := INF
	
	for obj in interactables_in_range:
		var distance := global_position.distance_to(obj.global_position)
		if distance < min_distance:
			min_distance = distance
			nearest = obj
	
	return nearest

func end_interaction() -> void:
	change_state(State.IDLE)
	current_interactable = null


# SEÑALES DEL ÁREA

func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("interactable"):
		interactables_in_range.append(body)

func _on_interaction_area_body_exited(body: Node2D) -> void:
	interactables_in_range.erase(body)

func _on_interaction_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("interactable"):
		interactables_in_range.append(area)

func _on_interaction_area_area_exited(area: Area2D) -> void:
	interactables_in_range.erase(area)
