extends Node
class_name enemy

var charName : String = "Big Gus"
var position : int = 0
var health : int = 100
var maxHealth : int = 100
var powerPoints : int = 100
var maxPowerPoints : int = 100
var healthLabel : Label
var offense : int = 182
var defense : int = 73
var speed : int = 11
var determination : int = 14
var specialAbility : String = "Innovation"
var specialMoveList : Array[String] = []
var specialMoveName : String = ""
var alive : bool = true
var action : String = ""
var statusEffect : Array[String] = []
var target
var deathMessage : String = "%s was defeated!" % [charName]
var shieldHealth : int = 0
var sprite : String = ""
var background : String = ""
var myUI : Control
var enemyMoves : int = 0
var allyTeam : Array[enemy] = []
var rivalTeam : Array[player] = []
