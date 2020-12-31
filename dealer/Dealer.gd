extends Node2D


# responsible for keeping score / starting the game / determining win or lose


const Card = preload("res://cards/Card.tscn")
const CARD_SPACING = 64


onready var deck = $Deck
onready var player_card_pos = get_node("../PlayerCardPos")
onready var dealer_card_pos = get_node("../DealerCardPos")


var player_cards = []
var dealer_cards = []
var last_player_card_pos: Vector2
var last_dealer_card_pos: Vector2


func _ready() -> void:
	randomize()
	deck.reset_deck()
	start_game()
	
	
func start_game():
	# deal 1 card up / down for dealer and 1 for player
	# break this out into a method that takes in a pos and player bool
	# add a point2d for the first dealer and player card to be placed
	deal_card(false,true)
	deal_card(false,false)
	
	deal_card(true,true)
	deal_card(true,true)

	# need to align pos2d and get size of the card sprite

func deal_card(to_player: bool, face_up: bool) -> void:
	# if not empty then use the pos2d
	var card_arr = deck.draw_card()
	var key = card_arr[0]
	var value = card_arr[1]
	var card_instance = Card.instance()
	card_instance.initialize(key, face_up)
	add_child(card_instance)

	if to_player:
		player_cards.append(value)
		if player_cards.size() == 1:
			card_instance.global_position = player_card_pos.position
		else:
			card_instance.global_position = last_player_card_pos + Vector2(CARD_SPACING,0)
		last_player_card_pos = card_instance.global_position
	else:
		dealer_cards.append(value)
		if dealer_cards.size() == 1:
			card_instance.global_position = dealer_card_pos.position
		else:
			card_instance.global_position = last_dealer_card_pos + Vector2(CARD_SPACING,0)
		last_dealer_card_pos = card_instance.global_position
