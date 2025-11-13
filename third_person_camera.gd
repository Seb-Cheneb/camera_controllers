class_name ThirdPersonCamera
extends Node

@export_category("References")
@export
var actor: Actor

@export_category("Properties")
@export_range(0, 100, 1)
var spring_arm_length: float = 1.0

@export_range(0.1, 20, 0.2)
var mouse_sensitivity: float = 1.0

@export_range(-360, 360, 10, "degrees")
var min_boundary: float:
	get:
		return rad_to_deg(_min_boundary)
	set(value):
		_min_boundary = deg_to_rad(value)

@export_range(-360, 360, 10, "degrees")
var max_boundary: float:
	get:
		return rad_to_deg(_max_boundary)
	set(value):
		_max_boundary = deg_to_rad(value)

@onready 
var horizontal_pivot: Node3D = $HorizontalPivot

@onready 
var vertical_pivot: Node3D = $HorizontalPivot/VerticalPivot

@onready 
var spring_arm: SpringArm3D = $SpringArm3D

var actor_direction: Vector3:
	get:
		if not _actor_direction:
			_actor_direction = actor.direction
		return _actor_direction
	set(value):
		_actor_direction = value
		actor.direction = value
var camera_direction: Vector2 = Vector2.ZERO		
var _actor_direction: Vector3
var _min_boundary: float
var _max_boundary: float


func _ready() -> void:
	Logs.check_reference(self, actor)
	Logs.check_reference(self, spring_arm)
	Logs.check_reference(self, horizontal_pivot)
	Logs.check_reference(self, vertical_pivot)
	spring_arm.spring_length = spring_arm_length
	

func _physics_process(_delta: float) -> void:
	horizontal_pivot.rotate_y(camera_direction.x)
	vertical_pivot.rotate_x(camera_direction.y)
	vertical_pivot.rotation.x = clampf(vertical_pivot.rotation.x, min_boundary, max_boundary)
	spring_arm.global_transform = vertical_pivot.global_transform
	camera_direction = Vector2.ZERO
	
	
func _unhandled_input(event: InputEvent) -> void:
	# only works if the mouse isn't seen (captured)
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			camera_direction = -event.relative * mouse_sensitivity
