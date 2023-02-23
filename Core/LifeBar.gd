extends ProgressBar

onready var progress_bar_2: ProgressBar = $ProgressBar2

func init(value):
	self.value = value
	progress_bar_2.value = value
	set_process(false)

func damage(value) -> float:
	if self.value - value >= 0:
		set_bar_value(self.value - value)
	return self.value 


func heal(item_name: String) -> float:
	if item_name == "healing_potion":
		set_bar_value(100)
	return self.value

func set_bar_value(value):
	self.value = value
	$Timer.stop()
	$Timer.start(0)
	if(value > $ProgressBar2.value):
		$ProgressBar2.value = value

func _on_Timer_timeout():
	set_process(true)

func _process(_delta):
	progress_bar_2.value = lerp(progress_bar_2.value, value, 0.1)
	if(progress_bar_2.value - value <= 0.5):
		progress_bar_2.value = value
		set_process(false)
