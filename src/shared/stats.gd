extends Node

export(int) var CON = 6
export(int) var STR = 5
export(int) var DEX = 5

onready var max_health = CON + roll(1,6)
onready var health = max_health

func hit(objective_stats):
	var defense = 10 + objective_stats.DEX
	return roll(1,20) + self.DEX > defense


func damage(objective_stats):
	var base_damage = roll(1,20)
	var damage_dices = 1
	if base_damage == 1:
		return 0 #FAIL
	if base_damage == 20:
		damage_dices *= 2 # CRIT
	
	return roll(damage_dices,4) + self.STR


func roll(dices, sides):
	var value = 0
	for i in range(dices):
		value += randi() % (sides + 1)
	return value
