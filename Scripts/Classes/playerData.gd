extends Node
class_name playerData

var info : Array[Dictionary] = [
	{
		"charName": Global.customPlayerNames[0] if not Global.customPlayerNames.is_empty() else Global.defaultPlayerNames[0], # Rafa
		"health": 178,
		"powerPoints": 100,
		"offense": 45,
		"defense": 28,
		"speed": 36,
		"determination": 37,
		"specialAbility": "PSI",
		"themeColor": "eee411",
		"sprite": "res://Resources/Sprites/Characters/rafa.svg",
		"ghostSprite": "res://Resources/Sprites/Death/Ghost Characters/rafaGhost.svg",
		"deathIconSprite": "res://Resources/Sprites/Death/Tombstone Icons/rafaDead.svg"
	},
	{
		"charName": Global.customPlayerNames[1] if not Global.customPlayerNames.is_empty() else Global.defaultPlayerNames[1], # Otávio
		"health": 260,
		"powerPoints": 0,
		"offense": 120,
		"defense": 52,
		"speed": 16,
		"determination": 17,
		"specialAbility": "Dark Arts",
		"themeColor": "7d00fa",
		"sprite": "res://Resources/Sprites/Characters/otávio.svg",
		"ghostSprite": "res://Resources/Sprites/Death/Ghost Characters/otávioGhost.svg",
		"deathIconSprite": "res://Resources/Sprites/Death/Tombstone Icons/otávioDead.svg"
	},
	{
		"charName": Global.customPlayerNames[2] if not Global.customPlayerNames.is_empty() else Global.defaultPlayerNames[2], # Gabriel
		"health": 304,
		"powerPoints": 0,
		"offense": 182,
		"defense": 105,
		"speed": 7,
		"determination": 21,
		"specialAbility": "Dev Tools",
		"themeColor": "c70013",
		"sprite": "res://Resources/Sprites/Characters/gabriel.svg",
		"ghostSprite": "res://Resources/Sprites/Death/Ghost Characters/gabrielGhost.svg",
		"deathIconSprite": "res://Resources/Sprites/Death/Tombstone Icons/gabrielDead.svg"
	},
	{
		"charName": Global.customPlayerNames[3] if not Global.customPlayerNames.is_empty() else Global.defaultPlayerNames[3], # Breno
		"health": 208,
		"powerPoints": 77,
		"offense": 87,
		"defense": 95,
		"speed": 18,
		"determination": 30,
		"specialAbility": "Caipira Powers",
		"themeColor": "2f7e00",
		"sprite": "res://Resources/Sprites/Characters/breno.svg",
		"ghostSprite": "res://Resources/Sprites/Death/Ghost Characters/brenoGhost.svg",
		"deathIconSprite": "res://Resources/Sprites/Death/Tombstone Icons/brenoDead.svg",
	},
	{
		"charName": Global.customPlayerNames[4] if not Global.customPlayerNames.is_empty() else Global.defaultPlayerNames[4], # Neto
		"health": 182,
		"powerPoints": 94,
		"offense": 60,
		"defense": 102,
		"speed": 33,
		"determination": 14,
		"specialAbility": "Friendship Magic",
		"themeColor": "fd00d2",
		"sprite": "res://Resources/Sprites/Characters/neto.svg",
		"ghostSprite": "res://Resources/Sprites/Death/Ghost Characters/netoGhost.svg",
		"deathIconSprite": "res://Resources/Sprites/Death/Tombstone Icons/netoDead.svg"
	},
]
