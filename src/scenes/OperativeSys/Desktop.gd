extends Node2D

signal project_started
signal password_changed

func _on_PasswordIcon_pressed():
	var mouse_pos = get_global_mouse_position()
	$Camera2D/Control/PasswordWindow.popup()
	$Camera2D/Control/PasswordWindow.set_position(mouse_pos)	


func _on_ProjectIcon_pressed():
	var mouse_pos = get_global_mouse_position()
	$Camera2D/Control/ProjectWindow.popup()
	$Camera2D/Control/ProjectWindow.set_position(mouse_pos)

func _on_project_start():
	$Camera2D/Control/ProjectWindow.hide()
	emit_signal("project_started")

func _on_pw_changed():
	$Camera2D/Control/PasswordWindow.hide()
	emit_signal("password_changed")
