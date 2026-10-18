# Project-Nayan

### Script actualizado (más rápido + 4 direcciones)

Reemplaza el script anterior por este:

```gdscript
extends CharacterBody2D

@export var speed: float = 180.0          # Más rápido que antes
@export var acceleration: float = 1200.0
@export var friction: float = 1400.0

# Dirección a la que mira el personaje (importante para animaciones e interacción)
var facing_direction: Vector2 = Vector2.DOWN

@onready var sprite: Sprite2D = $Sprite2D   # Cambia a AnimatedSprite2D cuando tengas animaciones

func _physics_process(delta: float) -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if input_vector != Vector2.ZERO:
		# Guardamos la dirección a la que mira (priorizamos la más fuerte)
		facing_direction = input_vector.normalized()
		
		# Movimiento con aceleración
		velocity = velocity.move_toward(input_vector * speed, acceleration * delta)
		
		# Actualizamos la apariencia según la dirección
		update_sprite_direction()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	move_and_slide()


func update_sprite_direction() -> void:
	# Versión simple con placeholder (Sprite2D)
	# Cuando tengas AnimatedSprite2D esto se cambia por play("walk_down"), etc.
	
	if abs(facing_direction.x) > abs(facing_direction.y):
		# Horizontal
		if facing_direction.x > 0:
			sprite.flip_h = false          # Derecha
			# Aquí más adelante: sprite.play("walk_right")
		else:
			sprite.flip_h = true           # Izquierda
			# Aquí más adelante: sprite.play("walk_left")
	else:
		# Vertical
		sprite.flip_h = false
		if facing_direction.y > 0:
			# Abajo
			pass
			# Aquí más adelante: sprite.play("walk_down")
		else:
			# Arriba
			pass
			# Aquí más adelante: sprite.play("walk_up")
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
