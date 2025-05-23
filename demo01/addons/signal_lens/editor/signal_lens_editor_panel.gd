## Draw's Signal Lens panel in the debugger bottom tab inside Godot's editor
## Parses data received from the runtime autoload into
## a user-friendly graph of a node's signal and its connections
@tool
class_name SignalLensEditorPanel
extends Control

## Written in the panel's line edit if nothing is selected and a debugger
## session is active
const TUTORIAL_TEXT: String = "Select a node in the remote scene"

## This enum is used to set up the graph node's ports 
## in a way that provides more legibility in the code
enum Direction {LEFT, RIGHT}

## Emitted on user pressed "refresh" button
signal node_data_requested(node_path)

## Current node path being inspected
var current_node: NodePath = ""

## If true, ignores new incoming data from the remote tree
## effectively locking the panel current node path
var block_new_inspections: bool = false

## Scene references
@export var graph_edit: GraphEdit 
@export var lock_button: Button 
@export var node_path_line_edit: LineEdit 
@export var refresh_button: Button 
@export var clear_button: Button
@export var inactive_text: Label

## Requests inspection of [param current_node] in remote scene
func request_node_data():
	node_data_requested.emit(current_node)

## Receives node signal data from remote scene
## Data structure is detailed further below
func receive_node_data(data: Array):
	draw_data(data)

## Sets up editor on project play
func start_session():
	clear_graph()
	lock_button.unlock()
	node_path_line_edit.placeholder_text = TUTORIAL_TEXT
	inactive_text.hide()

## Cleans up editor on project stop
func stop_session():
	clear_graph()
	lock_button.disabled = true
	refresh_button.disabled = true
	clear_button.disabled = true
	node_path_line_edit.text = ""
	lock_button.unlock()
	inactive_text.show()

## Assigns a [param target_node] to internal member [param current_node]
func assign_node_path(target_node: NodePath):
	# If locked button is toggled, don't change the current node
	if block_new_inspections: return
	
	# If incoming node is invalid, disable refreshing to avoid null nodes
	refresh_button.disabled = target_node.is_empty()
	
	# Assign incoming node as the current one
	current_node = target_node
	
	# Update line edit
	node_path_line_edit.text = current_node

#region Graph Rendering

## Clears all nodes from the debugger panel
## Called on user inspecting new node or on play/quit current
## debug session
func clear_graph():
	# If nothing in graph, return
	if graph_edit.get_child_count() == 0: return
	# Not clearing connection activity can lead to unwanted behaviour
	# So this function must be called here for now
	clean_connection_activity()
	# Frees child nodes
	for child: Node in graph_edit.get_children():
		# This seems to be necessary as per Godot 4.3 
		# because this child, despite being internal,
		# is iterated in get_children() and if it is
		# destroyed, the editor crashed
		# so let's ignore it and move on
		if child.name == "_connection_layer": continue
		child.free()
	# Necessary for the minimap to update, it seems
	graph_edit.minimap_enabled = false
	graph_edit.minimap_enabled = true

## Draws data received from the runtime autoload
## The data is packages in the following structure:
## Pseudo-code: [Name of target node, [All of the node's signals and each signal's respective callables]]
## Print result: [{&"name_of_targeted_node", [{"signal": "item_rect_changed", "callables": [{ "object_name": &"Control", "callable_method": "Control::_size_changed"}]]
## Is is parsed and drawin into nodes, with connections established between signals and their callables
func draw_data(data: Array):
	# If lock button toggled on, don't draw incoming data
	if block_new_inspections: return
	
	# Clear graph to avoid drawing over old data
	clear_graph()
	
	# This line is super important to avoid random rendering errors
	# It seems we need to give a small breathing room for the graph edit
	# to fully cleanup, otherwise, artifacts from a previously rendered
	# graph edit may appear and mess up the new drawing
	await get_tree().create_timer(0.1).timeout
	
	# TODO: Validations are needed here to avoid processing possible
	# invalid data array structures
	
	# Retrieve the targeted node from the data array, which is always index 0
	var target_node_name = data[0]

	# Retrieve the targeted node signal data, which is always index 1
	var target_node_signal_data: Array = data[1]
	
	# Create main node from which connections will be created
	# and add it to the graph
	var target_node: SignalLensGraphNode = create_node(target_node_name, "(Signals)")
	graph_edit.add_child(target_node)
	
	var current_signal_index = 0
	
	# Start iterating signal by signal
	for signal_data in target_node_signal_data:
		# Get the color based on the index so we can have the rainbow vibes
		var slot_color = get_slot_color(current_signal_index, target_node_signal_data.size())
		# Create the slot button with the signal's name
		create_button_slot(signal_data["signal"], target_node, Direction.RIGHT, slot_color)
		
		# Start iterating each callable in the signal
		var callables_for_current_signal = signal_data["callables"]
		for callable_index in range(callables_for_current_signal.size()):
			var object_name: String = callables_for_current_signal[callable_index]["object_name"]
			var callable_method: String = callables_for_current_signal[callable_index]["callable_method"]
			# If a node has already been created for the object that owns the callable
			# Then we don't create an entirely new node
			# Otherwise, we create a new node
			if graph_edit.has_node(object_name):
				var callable_node = graph_edit.get_node(object_name)
				# If callable's object is the same as signal's
				# It means that the target node listens to it's own signals
				# So we create a new node to avoid confusion and keep everything legible
				# for the user
				# Otherwise, we just add a new button to an already existing node
				if callable_node.name == target_node.name:
					var target_callables_node
					if !graph_edit.has_node(target_node_name + " (Callables)"):
						target_callables_node = create_node(target_node_name + " (Callables)")
						graph_edit.add_child(target_callables_node)
						target_callables_node.position_offset += Vector2(250, 0)
					else:
						target_callables_node = get_node(target_node_name + " (Callables)")
					create_button_slot(callable_method, target_callables_node, Direction.LEFT, slot_color)
					graph_edit.connect_node(target_node.name, current_signal_index, target_callables_node.name, target_callables_node.get_child_count() - 1)
				else:
					create_button_slot(callable_method, callable_node, Direction.LEFT, slot_color)
					graph_edit.connect_node(target_node.name, current_signal_index, callable_node.name, callable_node.get_child_count() - 1)
			else:
				var callable_node: SignalLensGraphNode = create_node(object_name, "(Callables)")
				create_button_slot(callable_method, callable_node, Direction.LEFT, slot_color)
				graph_edit.add_child(callable_node)
				# We set the offsets here to se can have the descending stair effect in the resulting graph
				# TODO: This could be a user setting
				callable_node.position_offset += Vector2(callable_node.get_index() * 250, callable_node.get_index() * 50)
				graph_edit.connect_node(target_node.name, current_signal_index, callable_node.name, callable_node.get_child_count() - 1)
		# Finally, we add to the current iterator and move on to the next signal
		current_signal_index += 1
	# Manage button states
	# This is important to make sure that if a valid graph is rendered
	# in case the buttons are disabled, they are enabled again
	if clear_button.disabled:
		clear_button.disabled = false
	if lock_button.disabled:
		lock_button.disabled = false

func create_node(node_name: String, title_appendix: String = "") -> SignalLensGraphNode:
	var new_node = SignalLensGraphNode.new()
	new_node.name = node_name
	new_node.title = node_name + " " + title_appendix
	return new_node

func create_button_slot(button_text: String, parent_node: GraphNode, slot_direction: Direction, slot_color: Color):
	var signal_button: Button = Button.new()
	signal_button.flat = true
	signal_button.text = button_text
	parent_node.add_child(signal_button)
	signal_button.pressed.connect(_on_signal_button_pressed.bind(parent_node, signal_button.get_index()))
	signal_button.focus_exited.connect(clean_connection_activity)
	parent_node.set_slot(signal_button.get_index(), slot_direction == Direction.LEFT, 0, slot_color, slot_direction == Direction.RIGHT, 0, slot_color)

func get_slot_color(slot_index, signal_amount) -> Color:
	var hue = float(slot_index) / float(signal_amount) 
	return Color.from_hsv(hue, 1.0, 0.5, 0.05)  

func clean_connection_activity():
	for connection in graph_edit.get_connection_list():
		graph_edit.set_connection_activity(connection["from_node"], connection["from_port"],  connection["to_node"], connection["to_port"], 0)

#endregion

#region Signal Callbacks

func _on_refresh_button_pressed() -> void:
	if current_node.is_empty(): return
	request_node_data()

func _on_signal_button_pressed(graph_node: GraphNode, internal_index: int):
	graph_edit.set_selected(null)
	clean_connection_activity()
	for connection in graph_edit.get_connection_list():
		if (connection["from_node"] == graph_node.name && connection["from_port"] == internal_index) or (connection["to_node"] == graph_node.name && connection["to_port"] == internal_index):
			graph_edit.set_connection_activity(connection["from_node"], connection["from_port"],  connection["to_node"], connection["to_port"], 0.9)

func _on_graph_edit_node_selected(node: Node) -> void:
	var graph_node = node as GraphNode
	for connection in graph_edit.get_connection_list():
		if connection["to_node"] == graph_node.name:
			graph_edit.set_connection_activity(connection["from_node"], connection["from_port"],  connection["to_node"], connection["to_port"], 0.9)

func _on_graph_edit_node_deselected(node: Node) -> void:
	var graph_node = node as GraphNode
	for connection in graph_edit.get_connection_list():
		if connection["to_node"] == graph_node.name:
			graph_edit.set_connection_activity(connection["from_node"], connection["from_port"],  connection["to_node"], connection["to_port"], 0)

func _on_clear_button_pressed() -> void:
	clear_graph()

func _on_repo_button_pressed() -> void:
	OS.shell_open("https://github.com/yannlemos/signal-lens")

func _on_lock_button_toggled(toggled_on: bool) -> void:
	block_new_inspections = toggled_on

#endregion
