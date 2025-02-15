extends CharacterBody2D


const SPEED = 90.0


func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		self.velocity = direction * SPEED
	else:
		self.velocity = Vector2.ZERO
		
	move_and_slide()
	
@onready var _animated_sprite = $AnimatedSprite2D
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_right"):
		_animated_sprite.play("right")
	elif Input.is_action_pressed("ui_left"):
		_animated_sprite.play("left")
	elif Input.is_action_pressed("ui_up"):
		_animated_sprite.play("top")
	elif Input.is_action_pressed("ui_down"):
		_animated_sprite.play("bot")
	else:
		_animated_sprite.stop()
