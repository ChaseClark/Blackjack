extends Node2D
class_name Card

const FORMAT_PATH := "res://assets/playing-cards-pack/PNG/Cards (large)/%s.png"


export (bool) var face_up setget set_face_up
export (String) var img_path



func set_face_up(value: bool):
	face_up = value
	display()
	


func initialize(img_path: String, face_up: bool) -> void:
	self.img_path = img_path
	self.face_up = face_up
	display()



func display():
	var sprite = $Sprite
	if face_up:
		if img_path and img_path.length() > 0:
			sprite.texture = load(FORMAT_PATH % img_path)
	else:
		sprite.texture = load(FORMAT_PATH % "card_back")
