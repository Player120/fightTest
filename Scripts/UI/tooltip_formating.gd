extends Button

@export var tooltipSize : float = 400.0
@onready var value : float = 0.0

func _ready() -> void:
	value = tooltipSize

func _make_custom_tooltip(for_text : String) -> Control:
	var label := Label.new()
	label.text = for_text
	
	# Connects the label to the settings that I defined for TooltipLabel in my theme file
	label.theme_type_variation = &"TooltipLabel"
	
	# Turning on word wrap and defining the tooltip's width
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.custom_minimum_size.x = value
	
	# Creates the panel's container and connects to the TooltipPanel in my theme in the .tres file
	var panel : PanelContainer = PanelContainer.new()
	panel.theme_type_variation = &"TooltipPanel"
	panel.add_child(label)
	
	return panel
