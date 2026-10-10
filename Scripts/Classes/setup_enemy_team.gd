extends Node
class_name setupEnemyTeam

var enemyClass = preload("res://Scripts/Classes/enemy.gd")
var enemyScene = preload("res://Prefabs/enemy_scene.tscn")

func setup(quantity : int, enemyArea : Control, background : TextureRect, enemyContainer : HBoxContainer, enemyTeam : Array[enemy], data : Array[Dictionary]):
	var limit = min(quantity, data.size())
	
	for i in (limit):
		#Setup enemy attributes
		var newEnemy : Node = enemyClass.new()
		newEnemy.name = "Enemy_" + str(i + 1)
		newEnemy.charName = data[i].charName
		newEnemy.position = i + 1
		newEnemy.health = data[i].health
		newEnemy.maxHealth = data[i].health
		newEnemy.offense = data[i].offense
		newEnemy.defense = data[i].defense
		newEnemy.speed = data[i].speed
		newEnemy.determination = data[i].determination
		newEnemy.specialAbility = data[i].specialAbility
		
		# Creating the enemy's special move list
		var specialList = Global.specialMoveslist[data[i].specialAbility]
		
		for ability in specialList:
			newEnemy.specialMoveList.append(ability)
		print("ENEMY SPECIAL MOVE LIST: ", newEnemy.specialMoveList)
		# ---------------------------------------
		
		newEnemy.deathMessage = "%s was defeated!" % [newEnemy.charName]
		newEnemy.sprite = data[i].sprite
		if (newEnemy.position == 1):
			background.texture = load(data[i].background)
		
		# Creates label with HP value
		var newScene : Control = enemyScene.instantiate()
		enemyContainer.add_child(newScene)
		
		# Linking one with the other
		# Passing the referenced data to the label update health
		newScene.initializeEnemy(newEnemy)
		
		# Storing the hp label inside of the own enemy if it is needed
		newEnemy.myUI = newScene
		newEnemy.healthLabel = newScene.hpNumber
		print(newEnemy.healthLabel)
		
		# Adding the node logic in the tree (as child of fight area)
		add_child(newEnemy)
		
		# Stores the enemy in the turn array
		enemyTeam.append(newEnemy)
		
		# Attributes the hp value to the label for the first time
		newScene.updateHealthText(newEnemy.health)
		print("%s enemy was created with the name %s, in position %d" % [newEnemy.name, newEnemy.charName, newEnemy.position])
