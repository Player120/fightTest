extends Node
class_name player

var charName : String = "Player"
var health : int = 100
const maxHealth : int = 100
var healthLabel : Label
var psychicPoints : int = 50
const maxPsychicPoints : int = 50
var psychicPointsLabel : Label
var psiName : String = ""
var offense : int = 25
var speed : int = 12
var determination : int = 30
var alive : bool = true
var action : String = ""
var statusEffect : Array[String] = []
var target : Node
var deathMessage : Array[String] = ["%s was hurt and beaten..." % [charName], "You lost the battle..."]
