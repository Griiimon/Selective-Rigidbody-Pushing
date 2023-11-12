extends RigidBody2D
class_name Unit

# set to a value between 0 and 1, higher value => less sticky
@export var bounce_factor: float= 0

var team: int


func _ready():
	# choose random team 0 or 1
	team= randi() % 2
	
	if team == 1:
		# color team 1 red
		$Sprite2D.modulate= Color.RED


func _integrate_forces(state):
	# check all collision contacts
	# make sure Contact Monitor is enabled and Max Contact Reported large enough
	for i in state.get_contact_count():
		var collider= state.get_contact_collider_object(i)
		if collider is Unit:
			# check if we collided with same team
			if team == collider.team:
				var normal: Vector2= state.get_contact_local_normal(i)
				
				# for bounce_factor = 0 this is effectively linear_velocity= Vector2.ZERO
				state.linear_velocity= normal * linear_velocity.length() * bounce_factor
				state.angular_velocity= 0

func _physics_process(delta):
	# apply random impulse once in a while
	if randf() < delta:
		apply_central_impulse(Vector2(randf() - 0.5, randf() - 0.5) * randf() * 150)

func _on_visible_on_screen_notifier_2d_screen_exited():
	# invert velocity when Unit leaves the screen
	linear_velocity*= -1
