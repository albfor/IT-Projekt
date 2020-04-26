extends KinematicBody2D
class_name Actor

puppet var player_pos = Vector2()

const FLOOR_NORMAL: = Vector2.UP

export var gravity: = 4000.0 
export var speed: = Vector2(300.0, 1000.0) # how quickly the actor is allowed to move
var velocity: = Vector2.ZERO # how quickly the actor moves
