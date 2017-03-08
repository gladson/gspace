extends Area2D

export var rot_speed = 2.6
export var thrust = 500
export var max_level = 400
export var friction = 0.65

# primeiro metodo
# onready var bullet = preload("res://scenes/player_bullet.tscn") 
# segundo metodo
export (PackedScene) var bullet

# chamando container bullet
onready var bullet_container = get_node("bullet_container")
# chamando gun timer
onready var gun_timer = get_node("gun_timer")

var screen_size = Vector2() # tamanho da tela
var rot = 0 # rotação
var pos = Vector2() # posição
var vel = Vector2() # velocidade
var acc = Vector2() # aceleração

func _ready():
	screen_size = get_viewport_rect().size
	pos = screen_size / 2
	set_pos(pos)
	set_process(true)

func _process(delta):
	if Input.is_action_pressed("ui_shoot"):
		if gun_timer.get_time_left() == 0:
			shoot()
	if Input.is_action_pressed("ui_left"):
		rot += rot_speed * delta
	if Input.is_action_pressed("ui_right"):
		rot -= rot_speed * delta
	if Input.is_action_pressed("ui_down"):
		acc = Vector2(thrust, 0).rotated(rot)
	else:
		acc = Vector2(0,0)
	
	acc += vel * -friction
	vel += acc * delta
	pos += vel * delta
	if pos.x > screen_size.width:
		pos.x = -25
	if pos.x < -25:
		pos.x = screen_size.width
	if pos.y > screen_size.height:
		pos.y = -25
	if pos.y < -25:
		pos.y = screen_size.height
	
	set_pos(pos)
	set_rot(rot - PI/2)
	
func shoot():
	gun_timer.start()
	var b = bullet.instance()
	bullet_container.add_child(b)
	b.start_at(get_rot(), get_node("muzzle").get_global_pos())