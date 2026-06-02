extends Node
class_name setupTeam

var playerClass = preload("res://Scripts/Classes/player.gd")
var playerWindowScene = preload("res://Prefabs/player_window.tscn")

func setup(
	quantity : int, windowContainer : HBoxContainer, actionMenu : Control, playerArea : Control, playerTeam : Array[player], data : Array[Dictionary]
) -> void:
	var limit : int = min(quantity, data.size())
	
	for i in range(limit):
		# Setup player attributes
		var newPlayer : Node = playerClass.new()
		newPlayer.name = "Player_" + str(i + 1)
		newPlayer.charName = data[i].charName
		newPlayer.position = i + 1
		newPlayer.health = data[i].health
		newPlayer.maxHealth = newPlayer.health
		newPlayer.powerPoints = data[i].powerPoints
		newPlayer.maxpowerPoints = newPlayer.powerPoints
		newPlayer.offense = data[i].offense
		newPlayer.speed = data[i].speed
		newPlayer.specialAbility = data[i].specialAbility
		newPlayer.deathMessage = "%s was hurt and beaten..." % [newPlayer.charName]
		
		# Creates UI window with name and HP/PP values
		var newWindow : Control = playerWindowScene.instantiate()
		windowContainer.add_child(newWindow)
		
		# Linking one with the other
		# Passing the referenced data to the window to update health/name
		newWindow.initializeWithPlayer(newPlayer)
		
		# Storing the window, hp label and pp label inside of the own player if it is needed
		newPlayer.myUI = newWindow
		newPlayer.healthLabel = newWindow.hpNumber
		newPlayer.powerPointsLabel = newWindow.ppNumber
		
		# Adding the node logic in the tree (as child of fight area)
		add_child(newPlayer)
		
		# Stores the player in the turn array
		playerTeam.append(newPlayer)
		
		# Attributes the hp and pp values to the labels for the first time
		playerArea.updateValues("health", newPlayer.health, newPlayer.myUI)
		playerArea.updateValues("powerPoints", newPlayer.powerPoints, newPlayer.myUI)
		#print("Player '%s' created" % [newPlayer])
