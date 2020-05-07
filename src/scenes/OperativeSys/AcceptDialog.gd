extends AcceptDialog

func _ready():
	var button = get_ok()
	button.set_text("")
	var texture = preload("res://src/resources/images/OS BLUE TEAM/skicka lösenord.png")
	button.set_button_icon(texture)
	
