extends CanvasLayer


func initialize(title_text: String, won: bool) -> void:
	var title = $PanelContainer/MarginContainer/VBoxContainer/Title
	title.text = title_text
	if won:
		title.modulate = Color.green
		for p in $ConfettiContainer.get_children():
			p.emitting = true
	else:
		title.modulate = Color.red

func _on_ResetButton_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene("res://Main.tscn")
