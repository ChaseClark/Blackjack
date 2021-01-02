extends Node2D
class_name Deck

# going to need methods like: draw_dealer(face_up: bool), draw_player()
var cards := {}

func reset_deck() -> void:
	var count := 1
	var file = File.new()
	file.open("res://assets/playing-cards-pack/PNG/Cards (large)/_cards52.res", file.READ)
	cards.clear() # reset
	while !file.eof_reached():
		var line_array: PoolStringArray = file.get_csv_line ()
		if line_array.size() == 1:
			var key: String = line_array[0]
			if key.length() > 0:
				# use count to determine value
				# since our csv file is ordered nicely
				cards[key] = get_card_value(count)
				# print(key,"  ", get_card_value(count))
				count += 1
				if count == 14:
					count = 1
	file.close()


func get_card_value(i: int) -> int:
	if i == 1:
		return 1 # Ace ,the dealer will worry about changing this value
	elif i <=9 and i >= 2:
		return i
	else:
		return 10
		
		
func draw_card() -> Array:
	# get array of keys left
	# get random index and remove that from dict
	# return key
	var keys: Array = cards.keys()
	keys.shuffle()
	#var i = randi() % keys.size() # pick a random card's key
	var i = rand_range(0,keys.size())
	var key = keys[i]
	var value = cards[key]
	# remove from dict
	if not cards.erase(key):
		return []
	return [key, value]
