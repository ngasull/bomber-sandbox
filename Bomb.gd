extends StaticBody2D

onready var anim_player = $AnimationPlayer

var age = 0
var area = 3
var exploding = false

func _ready():
	if not exploding:
		anim_player.play("bomb")

func _process(delta):
	age += delta
	
	if age > 3 and not exploding:
		anim_player.play("explosion_core")
		exploding = true

func _on_AnimationPlayer_animation_finished(anim_name):
	get_parent().remove_child(self)
