class_name ThirdPersonCamera
extends Node3D

signal campera_direction_changed(direction: Vector3)

@export_category("References")
@export
var actor: Actor

@export_category("Properties")
@export_range(0, 100, 1)
var spring_arm_length: float = 10.0

@export_range(0.1, 20, 0.2)
var mouse_sensitivity: float = 1.0

@export_range(-360, 360, 10, "degrees")
var min_boundary: float:
	get:
		return min_boundary
	set(value):
		min_boundary = deg_to_rad(value)

@export_range(-360, 360, 10, "degrees")
var max_boundary: float:
	get:
		return max_boundary
	set(value):
		max_boundary = deg_to_rad(value)

#var actor_direction: Vector3:
	#get:
		#if not actor_direction:
			#actor_direction = actor.direction
		#return actor_direction
	#set(value):
		#actor.direction = value
		#actor_direction = value

var camera_input_direction: Vector2 = Vector2.ZERO	

@onready
var horizontal_pivot: ThirdPersonCamera = $"."

@onready
var vertical_pivot: Node3D = $VerticalPivot

@onready
var spring_arm: SpringArm3D = $VerticalPivot/SpringArm3D


func _ready() -> void:
	Logs.check_reference(self, actor, "actor")
	spring_arm.spring_length = spring_arm_length
	

func _physics_process(delta: float) -> void:
	horizontal_pivot.rotate_x(camera_input_direction.y * delta)
	#rotation.x += camera_input_direction.y * delta
	horizontal_pivot.rotation.x = clampf(rotation.x, -PI / 6.0, PI / 3.0)
	
	vertical_pivot.rotate_y(camera_input_direction.x * delta)
	#horizontal_pivot.rotate_y(camera_input_direction.x)
	#vertical_pivot.rotate_x(camera_input_direction.y)
	#vertical_pivot.rotation.x = clampf(vertical_pivot.rotation.x, min_boundary, max_boundary)
	#spring_arm.global_transform = vertical_pivot.global_transform
	
	# reset the direction so the camera will stop rotating once the input stop
	camera_input_direction = Vector2.ZERO
	
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion:
		camera_input_direction = event.screen_relative * mouse_sensitivity
