extends Node
class_name boss

var charName : String = "Big Gus"
var health : int = 300
const maxHealth : int = 300
var healthLabel : Label
var offense : int = 40
var speed : int = 10
var determination : int = 10
var alive : bool = true
var action : String = ""
var statusEffect : Array[String] = []
var target : Node
var deathMessage : String = "%s was defeated!" % [charName]
