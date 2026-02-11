@tool
extends BoxContainer
var tasks : Array = []
var tabs : String
var data :Array= []
var currentTab : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Load()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if $VBoxContainer2/Task.text == "":
		$Buttons_Container/Add.disabled = true
		pass
	else:
		$Buttons_Container/Add.disabled = false
	pass




func _on_add_pressed() -> void:
	Add_Task()
	pass # Replace with function body.

func Add_Task():
	var task : CheckBox = CheckBox.new()
	var taskName :String = $VBoxContainer2/Task.text
	task.text = taskName
	task.pressed.connect(Clear)
	get_current_tap().get_child(0).add_child(task)
	$VBoxContainer2/Task.clear()
	pass


func Clear() -> void:
	var tween = create_tween()
	var children = get_current_tap().get_child(0).get_children()
	for child in children:
		if child.button_pressed == true:
			tween.tween_property(child,"modulate",Color(1.0, 1.0, 1.0, 0.0),0.3)
			await tween.finished
			child.queue_free()
		else:
			data.append(child.text)
	Save()
	data.clear()
	pass # Replace with function body.






func Save():
	print("C")
	var path = FileAccess.open("user://save.json",FileAccess.WRITE)
	var json = JSON.stringify(data)
	path.store_string(json)
	path.close()
	print(json)
	pass



func Load():
	if FileAccess.file_exists("user://save.json"):
		var path = FileAccess.open("user://save.json",FileAccess.READ)
		var stringfyData = path.get_as_text()
		path.close()
		var Data = JSON.parse_string(stringfyData)
		data = Data
		for details in data:
			var tab_name = details[0]
			var Tasks = details[1]
			var tab = TabBar.new()
			tab.name = tab_name
			for CBox in Tasks:
				var Task = CheckBox.new()
				Task.text = CBox
				tab.add_child(Task)
				Task.pressed.connect(Clear)
				pass
			$VBoxContainer/Panel/TabContainer.add_child(tab)
			pass
		pass
func _on_save_pressed() -> void:
	for child in $VBoxContainer/Panel/TabContainer.get_children():
		tabs = child.name
		for Tasks in child.get_child(0).get_children():
			tasks.append(Tasks.text)
			pass
		data.append([tabs,tasks.duplicate()])
		tasks.clear()
	Save()
	data.clear()
	pass # Replace with function body.


func _on_info_pressed() -> void:
	$Window.popup()
	pass # Replace with function body.


func _on_window_close_requested() -> void:
	$Window.hide()
	pass # Replace with function body.


func _on_misson_editing_toggled(toggled_on: bool) -> void:
	if toggled_on:
		if Input.is_action_just_pressed("ui_accept"):
			Add_Task()
			pass
	pass # Replace with function body.


func _on_add_tap_pressed() -> void:
	$"VBoxContainer/Panel/Add_Tap/Task's Tab Name".popup()
	pass # Replace with function body.


func _on_task_name_pressed() -> void:
	$"VBoxContainer/Panel/Add_Tap/Task's Tab Name/Task_Name".disabled = true
	var tab = TabBar.new()
	tab.add_child(VBoxContainer.new())
	tab.name = $"VBoxContainer/Panel/Add_Tap/Task's Tab Name/TextEdit".text
	$VBoxContainer/Panel/TabContainer.add_child(tab)
	$"VBoxContainer/Panel/Add_Tap/Task's Tab Name/TextEdit".clear()
	$"VBoxContainer/Panel/Add_Tap/Task's Tab Name".hide()
	pass # Replace with function body.


func _on_text_edit_text_changed() -> void:
	if $"VBoxContainer/Panel/Add_Tap/Task's Tab Name/TextEdit".text != "":
		$"VBoxContainer/Panel/Add_Tap/Task's Tab Name/Task_Name".disabled = false
		pass
	else:
		$"VBoxContainer/Panel/Add_Tap/Task's Tab Name/Task_Name".disabled = true
	pass # Replace with function body.


func _on_tab_container_tab_selected(tab: int) -> void:
	currentTab = tab
	print(currentTab)
	pass # Replace with function body.
func get_current_tap():
	return $VBoxContainer/Panel/TabContainer.get_current_tab_control()
	pass
