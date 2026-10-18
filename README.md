# Project-Nayan

### Script actualizado



```gdscript
extends CharacterBody2D

# --- Exportaciones ---
@export var speed: float = 180.0
@export var acceleration: float = 1200.0
@export var friction: float = 1400.0

# --- Estados ---
enum State { IDLE, WALK, INTERACTING }
var current_state: State = State.IDLE

# --- Variables ---
var facing_direction: Vector2 = Vector2.DOWN
var interactables_in_range: Array[Node] = []
var current_interactable: Node = null

# --- Referencias ---
@onready var sprite: Sprite2D = $Sprite2D
@onready var interaction_area: Area2D = $InteractionArea


func _ready() -> void:
	interaction_area.body_entered.connect(_on_interaction_area_body_entered)
	interaction_area.body_exited.connect(_on_interaction_area_body_exited)
	interaction_area.area_entered.connect(_on_interaction_area_area_entered)
	interaction_area.area_exited.connect(_on_interaction_area_area_exited)


func _physics_process(delta: float) -> void:
	match current_state:
		State.IDLE, State.WALK:
			handle_movement(delta)
			handle_interaction_input()
			update_state()
		State.INTERACTING:
			velocity = Vector2.ZERO
			move_and_slide()


# ======================
# MOVIMIENTO
# ======================
func handle_movement(delta: float) -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if input_vector != Vector2.ZERO:
		facing_direction = input_vector.normalized()
		velocity = velocity.move_toward(input_vector * speed, acceleration * delta)
		update_sprite_direction()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	move_and_slide()


func update_sprite_direction() -> void:
	if abs(facing_direction.x) > abs(facing_direction.y):
		sprite.flip_h = facing_direction.x < 0
	else:
		sprite.flip_h = false


# ======================
# MÁQUINA DE ESTADOS
# ======================
func update_state() -> void:
	if velocity.length() > 5.0:
		change_state(State.WALK)
	else:
		change_state(State.IDLE)


func change_state(new_state: State) -> void:
	if current_state == new_state:
		return
	
	current_state = new_state
	
	match current_state:
		State.INTERACTING:
			velocity = Vector2.ZERO


# ======================
# INTERACCIÓN
# ======================
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


# ======================
# SEÑALES DEL ÁREA
# ======================
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
```

### Cómo dejar el placeholder decente ahora mismo

Mientras no tengas sprites:

1. En el `Sprite2D` pon cualquier textura (aunque sea un cuadrado blanco).
2. En el Inspector del Sprite2D → **Modulate** ponle un color que se vea bien (por ejemplo un tono piel o azul suave).
3. Ajusta el tamaño del `CollisionShape2D` para que sea un poco más estrecho que el sprite.

Cuando tengas los sprites de 4 direcciones, lo ideal es cambiar el `Sprite2D` por un **AnimatedSprite2D** y crear estas animaciones:

- `idle_down` / `walk_down`
- `idle_up` / `walk_up`
- `idle_left` / `walk_left`
- `idle_right` / `walk_right`

(El código de arriba ya está preparado para eso, solo hay que descomentar y ajustar).

---
