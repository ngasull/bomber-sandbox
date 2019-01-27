extends KinematicBody2D

const BOMB = preload("Bomb.tscn")
const DIR_VECTORS = { 'right': Vector2(1, 0),
                      'left': Vector2(-1, 0),
                      'up': Vector2(0, -1),
                      'down': Vector2(0, 1)}
const TILE_SIZE = 16

onready var anim_player = $AnimationPlayer
onready var raycasts = { 'right': $RayCastRight,
                         'left': $RayCastLeft,
                         'up': $RayCastUp,
                         'down': $RayCastDown }
onready var sprite = $BombermanSprite

var isMoving = false

var inputDirection = null
var newDirection = "down"
var newMoving = false

func _ready():
	$Tween.start()
	
func _process(delta):
	var direction = newDirection
	inputDirection = "right" if Input.is_action_pressed("move_right") else \
                     "left" if Input.is_action_pressed("move_left") else \
                     "up" if Input.is_action_pressed("move_up") else \
                     "down" if Input.is_action_pressed("move_down") else \
                     null

	#if inputDirection != null:
	#	move_and_slide(DIR_VECTORS[inputDirection] * TILE_SIZE * 10)
	if !newMoving:
		if Input.is_action_pressed("bomb") and !$RayCastBombHere.is_colliding():
			var bomb = BOMB.instance()
			get_node("/root/World").add_child(bomb)
			bomb.set_position(position)
		elif inputDirection != null:
			move(inputDirection)
			pass

	if newMoving and (!isMoving or newDirection != direction):
		if newDirection == "left":
			anim_player.play("walk_right")
			sprite.flip_h = true
		else:
			anim_player.play("walk_" + newDirection)
			sprite.flip_h = false
	elif !newMoving and (isMoving or newDirection != direction):
		if newDirection == "left":
			anim_player.play("idle_right")
			sprite.flip_h = true
		else:
			anim_player.play("idle_" + newDirection)
			sprite.flip_h = false
	isMoving = newMoving

func _on_Tween_tween_completed(object, key):
	newMoving = false

func move(direction):
	newDirection = inputDirection

	if !raycasts[direction].is_colliding():
		$Tween.interpolate_property(
			self,
			"position",
			position,
			position + DIR_VECTORS[direction] * TILE_SIZE,
			0.2,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN_OUT
		)
		newMoving = true
	else:
		print(!raycasts[direction].get_collider())
