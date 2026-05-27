extends Label

var bossStatus : boss

func _ready() -> void:
	bossStatus = boss.new()
	self.text = str(bossStatus.getBossHealth())
