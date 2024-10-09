# Handles the Player jump attack ability.
extends HitBoxComponent

@export var jump_controller : JumpController ## The JumpController of the player.


func _ready() -> void:
	if jump_controller == null:
		print(self.name, " has no jump_contorller")
		return
	
	area_entered.connect(on_area_entered)


func on_area_entered(other_area: Area2D):
	if not other_area is HurtBoxComponent:
		return
	
	var degrees = round(rad_to_deg(jump_controller.player.get_angle_to(other_area.global_position)))
	var player_y_velocity = jump_controller.player.velocity.y
	if player_y_velocity > 0:
		if degrees > 35 and degrees < 125:
			other_area.took_damage.emit(damage) # Emit the took_damage signal from the HurtBoxComponent that was collided with
			jump_controller.player.velocity.y = jump_controller.jump_velocity
