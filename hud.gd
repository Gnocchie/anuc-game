extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game
signal easy_mode
signal hard_mode

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over(text):
	show_message(text)
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "Try Again ?"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	$CheckButton.show()
	
func update_score(score):
	$ScoreLabel.text = str(score)
	
func _on_message_timer_timeout():
	$Message.hide()
	
func _on_start_button_pressed():
	$StartButton.hide()
	$CheckButton.hide()
	start_game.emit()

func _on_check_button_toggled(toggled_on: bool):
	if toggled_on:
		hard_mode.emit()
	else:
		easy_mode.emit()
