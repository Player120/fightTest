extends Node
class_name boss

var charName : String = "Big Gus"
var health : int = 3600
const maxHealth : int = 3600
var healthLabel : Label
var offense : int = 150
var defense : int = 70
var speed : int = 11
var determination : int = 14
var specialAbility : String = "Innovation"
var specialMoveName : String = ""
var alive : bool = true
var action : String = ""
var statusEffect : Array[String] = []
var target
var deathMessage : String = "%s was defeated!" % [charName]
