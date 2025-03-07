extends GridContainer

@export var p:Property

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if p:
		$ProgressBar.value=p.current
		$ProgressBar.max_value=p.max
		$ProgressBar.min_value=p.min
