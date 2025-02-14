extends Button

var cooldown_timer=null
# 冷却时间
@export var cooldown_duration=2.0
var colldown_timer:Timer=null
var orginal_text=''


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	防止初始化时直接显示“冷却”信息
	set_process(false)
#	初始化定时器
	colldown_timer=$Timer
	orginal_text=self.text

# 如果冷却计时器没有停止 则退出，否则执行技能，然后动冷却计时器
func use_skill():
	if not colldown_timer.is_stopped():
		return
	update_button_text(true)
#	这里可以自定义你的技能逻辑了
	print("执行成功")

# true：开启冷却计时器。false冷却完毕
func update_button_text(is_on_cooldown:bool):
	if is_on_cooldown:
		set_process(true)
		colldown_timer.start(cooldown_duration)
		self.disabled=true
	else:
		self.text=orginal_text
		set_process(false)
		colldown_timer.stop()
		self.disabled=false

func _process(delta: float) -> void:
	self.text="冷却中：%.1f" %colldown_timer.time_left

func _on_Timer_timeout():
	update_button_text(false)
