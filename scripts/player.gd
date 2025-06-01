extends Area2D

@onready var phys_cast: RayCast2D = $CollisionCast
@onready var int_cast: RayCast2D = $InteractableCast
@onready var label: Label = self.get_node("Label")

const TILE_SIZE = 16
var inputs = {
	"right":Vector2.RIGHT,
	"left":Vector2.LEFT,
	"up":Vector2.UP,
	"down":Vector2.DOWN
}

var moving = false
var anim_speed = 7.8
var interacting = false

func _ready(): # Make sure player starts in a tile position
	position = position.snapped(Vector2.ONE * TILE_SIZE)
	position += Vector2.ONE * TILE_SIZE/2
	
	pass

func _physics_process(delta: float):
	if Input.is_action_just_released("interact"):
		interacting = false
		print("not interacting")
	
	if Input.is_action_pressed("down"):
		move("down")
		label.text = "↓"
	elif Input.is_action_pressed("up"):
		move("up")
		label.text = "↑"
	elif Input.is_action_pressed("left"):
		move("left")
		label.text = "←"
	elif Input.is_action_pressed("right"):
		move("right")
		label.text = "→"
	elif Input.is_action_pressed("interact"):
		if interacting == true:
			pass
		else:
			interacting = true
			print("huge interactable found")

#func _unhandled_input(event: InputEvent):
	#if moving:
		#return
	#for dir in inputs.keys():
		#if event.is_action_pressed(dir):
			#move(dir)

func move(dir):
	if moving:
		return
	
	int_cast.target_position  = inputs[dir] * TILE_SIZE
	phys_cast.target_position = inputs[dir] * TILE_SIZE
	phys_cast.force_raycast_update()
	if !phys_cast.is_colliding():
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", position+inputs[dir] * TILE_SIZE, 1.0/anim_speed).set_trans(Tween.TRANS_LINEAR)
		moving = true
		await tween.finished
		moving = false
