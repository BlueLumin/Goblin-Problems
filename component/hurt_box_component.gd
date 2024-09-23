extends Area2D
class_name HurtBoxComponent

signal took_damage(amount: int)
signal move_away_from_damage(collison_positon : Vector2)

func _ready() -> void:
	area_entered.connect(on_area_entered)


func on_area_entered(other_area: Area2D):
	if not other_area is HitBoxComponent:
		return
	
	move_away_from_damage.emit(other_area.position)
	
	took_damage.emit(other_area.damage)
