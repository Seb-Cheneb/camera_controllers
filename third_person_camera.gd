class_name ThirdPersonCamera
extends Node3D

signal camera_changed_direction(forward_vector: Vector3)

@export_category("References")
@export
var actor: Actor

@export_category("Properties")
@export
var spring_arm_length: float = 10.0

@export
var mouse_sensitivity: float = 1.0

@export_range(-80.0, 0.0, 1.0, "degrees")
var min_pitch_degrees: float = -45.0

@export_range(0.0, 80.0, 1.0, "degrees")
var max_pitch_degrees: float = 45.0

var camera_input := Vector2.ZERO

@onready
var yaw_pivot: Node3D = self

@onready
var pitch_pivot: Node3D = %PitchPivot

@onready
var spring_arm: SpringArm3D = %SpringArm


func _ready() -> void:
	spring_arm.spring_length = spring_arm_length


func _unhandled_input(event: InputEvent) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion:
		camera_input = -event.screen_relative * mouse_sensitivity


func _physics_process(delta: float) -> void:
	# --- Yaw (rotate around Y axis only)
	yaw_pivot.rotate_y(camera_input.x * delta)

	# --- Pitch (rotate around X axis only)
	pitch_pivot.rotate_x(-camera_input.y * delta)

	# Clamp pitch
	pitch_pivot.rotation_degrees.x = clampf(
		pitch_pivot.rotation_degrees.x,
		min_pitch_degrees,
		max_pitch_degrees
	)
	
	# emit the forward vector of the pitch pivot
	camera_changed_direction.emit(pitch_pivot.global_transform.basis.z)
	
	# Reset input
	camera_input = Vector2.ZERO
