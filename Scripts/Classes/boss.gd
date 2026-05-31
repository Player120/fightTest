extends Node
class_name boss

var charName : String = "Big Gus"
var health : int = 200
const maxHealth : int = 200
var healthLabel : Label
var offense : int = 35
var speed : int = 10
var determination : int = 10
var alive : bool = true
var action : String = ""
var statusEffect : Array[String] = []
var target : Node
var deathMessage : Array[String] = ["%s was defeated!" % [charName], "You won!"]
