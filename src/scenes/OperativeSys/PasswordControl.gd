extends Control

func _ready():
	$AcceptDialog.get_ok().set_text("Byt lösenord")
	$ProjectWindow.get_ok().set_text("Skicka")
	

func _on_PasswordIcon_pressed():
	var mouse_pos = get_global_mouse_position()
	$AcceptDialog.popup()
	$AcceptDialog.set_position(mouse_pos)	


func _on_ProjectIcon_pressed():
	var mouse_pos = get_global_mouse_position()
	$ProjectWindow.popup()
	$ProjectWindow.set_position(mouse_pos)
