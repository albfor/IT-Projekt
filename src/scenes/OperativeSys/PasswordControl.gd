extends Control

func _on_PasswordIcon_pressed():
	#var computer_pos = get_parent().get_parent().get_parent().position
	#print(computer_pos)
	#computer_pos.x += 400
	#computer_pos.y += 800
	#$AcceptDialog.set_position(computer_pos)
	$AcceptDialog.popup()


func _on_ProjectIcon_pressed():
	$ProjectWindow.popup()
	
