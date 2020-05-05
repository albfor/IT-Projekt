extends Node2D

func _ready():
	$Control.hide()
	

func _on_blue_team_button_up():
	$blue_team.hide()
	$Control.show()

func _on_red_team_button_up():
	queue_free()


func _on_ItemList_item_activated(index):
	print('Role ' + $Control/ItemList.get_item_text(index) + ' selected.')
	queue_free()
