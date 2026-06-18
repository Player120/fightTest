extends Node
class_name player

var charName : String = "Player"
var position : int = 0
var health : int = 100
var maxHealth : int = 100
var powerPoints : int = 50
var maxpowerPoints : int = 50
var offense : int = 25
var defense : int = 25
var speed : int = 12
var determination : int = 30
var specialAbility : String = ""
var healthLabel : Label
var powerPointsLabel : Label
var specialMoveName : String = ""
var alive : bool = true
var action : String = ""
var statusEffect : Array[String] = []
var target
var deathMessage : String = "%s was hurt and beaten..." % [charName]
var myUI : Control
var themeColor : Color
var canBeTargeted = true
var shieldHealth : int = 0
var sprite : String = ""
