extends Node2D


# responsible for keeping score / starting the game / determining win or lose


const Card = preload("res://cards/Card.tscn")
const CARD_SPACING = 40

onready var deck = $Deck
onready var player_card_pos = get_node("../PlayerCardPos")
onready var dealer_card_pos = get_node("../DealerCardPos")
onready var hit_button = get_node("../UI/MarginContainer/HBoxContainer/LeftVbox/HitButton")
onready var stand_button = get_node("../UI/MarginContainer/HBoxContainer/LeftVbox/StandButton")
onready var reset_button = get_node("../UI/MarginContainer/HBoxContainer/LeftVbox/ResetButton")
onready var player_score_label = get_node("../PlayerScoreLabel")
onready var dealer_score_label = get_node("../DealerScoreLabel")
onready var card_tween = $CardTween


var player_cards = []
var dealer_cards = []
var last_player_card_pos: Vector2
var last_dealer_card_pos: Vector2
var player_score
var dealer_score
var face_down_card


func _ready() -> void:
	start_game()
	
	
func start_game():
	# deal 1 card up / down for dealer and 1 for player
	# break this out into a method that takes in a pos and player bool
	# add a point2d for the first dealer and player card to be placed
	# start with buttons disabled
	randomize()
	deck.reset_deck()
	hit_button.disabled = true
	stand_button.disabled = true
	dealer_score_label.text = "Dealer Score: ???"
	player_score_label.text = "Player Score: ???"
	
	# 2 to dealer
	deal_card(false,true)
	yield(card_tween,"tween_completed")
	deal_card(false,false)
	yield(card_tween,"tween_completed")
	# 2 to player, face up
	deal_card(true,true)
	yield(card_tween,"tween_completed")
	deal_card(true,true)
	yield(card_tween,"tween_completed")
	
	calculate_player_score()
	# enable both hit and stay buttons
	hit_button.disabled = false
	stand_button.disabled = false

func deal_card(to_player: bool, face_up: bool) -> void:
	# if not empty then use the pos2d
	var card_arr = deck.draw_card()
	var key = card_arr[0]
	var value = card_arr[1]
	var card_instance = Card.instance()
	card_instance.initialize(key, face_up)
	add_child(card_instance)
	var sprite = card_instance.get_node("Sprite")
	# calculated spacing between dealt cards
	var card_offset = Vector2(CARD_SPACING,0) + Vector2(sprite.texture.get_size().x,0) * card_instance.scale.x / 2

	if to_player:
		player_cards.append(value)
		if player_cards.size() == 1:
			card_tween_to_pos(card_instance,global_position,player_card_pos.global_position)
			last_player_card_pos = player_card_pos.global_position
		else:
			card_tween_to_pos(card_instance,global_position,last_player_card_pos + card_offset)
			last_player_card_pos += card_offset
	else:
		dealer_cards.append(value)
		if dealer_cards.size() == 1:
#			card_instance.global_position = dealer_card_pos.position
			card_tween_to_pos(card_instance,global_position,dealer_card_pos.global_position)
			last_dealer_card_pos = dealer_card_pos.global_position
		else:
#			card_instance.global_position = last_dealer_card_pos + card_offset
			card_tween_to_pos(card_instance,global_position,last_dealer_card_pos + card_offset)
			last_dealer_card_pos += card_offset
			face_down_card = card_instance
	

func card_tween_to_pos(card: Card, start_pos: Vector2, end_pos: Vector2) -> void:
	card_tween.interpolate_property(card, "global_position",
		start_pos, end_pos, 0.6,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	card_tween.start()
	


func calculate_player_score() -> void:
	var score := 0
	var aces = 0
	for value in player_cards:
		if value == 1: #ace
			aces += 1 #default evaluating aces as one
		score += value
	
	if aces > 0:
		if score + 10 <= 21:
			score += 10
			
	player_score = score
	player_score_label.text = "Player Score: " + str(score)


func calculate_dealer_score() -> void:
	var score := 0
	var aces = 0
	for value in dealer_cards:
		if value == 1: #ace
			aces += 1 #default evaluating aces as one
		score += value
	
	if aces > 0:
		if score + 10 <= 21:
			score += 10
			
	dealer_score = score
	dealer_score_label.text = "Dealer Score: " + str(score)
	

func lost():
	print("player loses! score:", player_score)
		

func won():
	print("you beat the dealer!")
	

func tied():
	print("you tied the dealer!")
	

func _on_HitButton_pressed() -> void:
	hit_button.disabled = true
	deal_card(true,true)
	calculate_player_score()
	if player_score > 21:
		lost()
		hit_button.disabled = true
		stand_button.disabled = true
		reset_button.disabled = false
	else:
		hit_button.disabled = false
	
	
func _on_StandButton_pressed() -> void:
	hit_button.disabled = true
	stand_button.disabled = true
	face_down_card.face_up = true
	calculate_dealer_score()
	# dealer hit until value <= 17
#	for i in range(4):
#		deal_card(false,true)
#		yield(card_tween,"tween_completed")
#		calculate_dealer_score()
	while dealer_score < 17 or dealer_score < player_score:
		deal_card(false, true)
		yield(card_tween,"tween_completed")
		calculate_dealer_score()
	# check who wins
	if dealer_score > player_score and dealer_score <= 21:
		lost()
	elif dealer_score == player_score and dealer_score <= 21:
		tied()
	else:
		won()
	

func _on_ResetButton_pressed() -> void:
	get_tree().change_scene("res://Main.tscn")
