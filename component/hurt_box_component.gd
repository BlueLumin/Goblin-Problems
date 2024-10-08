# A component that can be added as a child to a node.
# Handles the on_area_entered signal and passes damage from a HitBoxComponent through a signal that is listened to from a HealthComponent.
extends Area2D
class_name HurtBoxComponent

signal took_damage(amount: int)
signal move_away_from_damage(collison_positon : Vector2)

func _ready() -> void:
	area_entered.connect(on_area_entered)


# If the area entered is a HitBoxComponent, emit the took_damage signal and pass through the damage from the HitBoxComponent.
func on_area_entered(other_area: Area2D):
	if not other_area is HitBoxComponent:
		return
	
	move_away_from_damage.emit(other_area.position) # Emit a signal that passes through the HitBoxComponent position so the player can bounce away from it.
	
	took_damage.emit(other_area.damage)
