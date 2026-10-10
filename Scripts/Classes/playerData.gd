extends Node
class_name playerData

var info : Array[Dictionary] = [
	{
		"charName": Global.customPlayerNames[0] if not Global.customPlayerNames.is_empty() else Global.defaultPlayerNames[0], # Rafa
		"health": 170,
		"powerPoints": 100,
		"offense": 45,
		"defense": 28,
		"speed": 22,
		"determination": 35,
		"specialAbility": "PSI",
		"themeColor": "eee411",
		"sprite": "res://Resources/Sprites/Characters/rafa.svg"
	},
	{
		"charName": Global.customPlayerNames[1] if not Global.customPlayerNames.is_empty() else Global.defaultPlayerNames[1], # Otávio
		"health": 250,
		"powerPoints": 0,
		"offense": 110,
		"defense": 52,
		"speed": 14,
		"determination": 17,
		"specialAbility": "Dark Arts",
		"themeColor": "7d00fa",
		"sprite": "res://Resources/Sprites/Characters/otávio.svg"
	},
	{
		"charName": Global.customPlayerNames[2] if not Global.customPlayerNames.is_empty() else Global.defaultPlayerNames[2], # Gabriel
		"health": 300,
		"powerPoints": 0,
		"offense": 170,
		"defense": 95,
		"speed": 7,
		"determination": 21,
		"specialAbility": "Dev Tools",
		"themeColor": "c70013",
		"sprite": "res://Resources/Sprites/Characters/gabriel.svg"
	},
	{
		"charName": Global.customPlayerNames[3] if not Global.customPlayerNames.is_empty() else Global.defaultPlayerNames[3], # Breno
		"health": 200,
		"powerPoints": 77,
		"offense": 87,
		"defense": 95,
		"speed": 18,
		"determination": 30,
		"specialAbility": "Caipira Powers",
		"themeColor": "2f7e00",
		"sprite": "res://Resources/Sprites/Characters/breno.svg"
	},
	{
		"charName": Global.customPlayerNames[4] if not Global.customPlayerNames.is_empty() else Global.defaultPlayerNames[4], # Neto
		"health": 180,
		"powerPoints": 94,
		"offense": 60,
		"defense": 102,
		"speed": 33,
		"determination": 14,
		"specialAbility": "Friendship Magic",
		"themeColor": "fd00d2",
		"sprite": "res://Resources/Sprites/Characters/neto.svg"
	},
]
