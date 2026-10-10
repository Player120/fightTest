extends Node
class_name teamAssignments

func assignTeams(playerTeam : Array[player], enemyTeam : Array[enemy]):
	for member in playerTeam:
		Global.playerTeam.append(member)
		#print("Assigned %s to the PLAYER TEAM" % [member.charName])
	
	for member in enemyTeam:
		Global.enemyTeam.append(member)
		#print("Assigned %s to the ENEMY TEAM" % [member.charName])

func assignRivals(playerTeam : Array[player], enemyTeam : Array[enemy]) -> void:
	for member in playerTeam:
		for rival in enemyTeam:
			member.rivalTeam.append(rival)
			#print("Assigned to %s from the PLAYER TEAM the rival %s" % [member.charName, rival.charName])
	
	for member in enemyTeam:
		Global.enemyTeam.append(member)
		for rival in playerTeam:
			member.rivalTeam.append(rival)
			#print("Assigned to %s from the ENEMY TEAM the rival %s" % [member.charName, rival.charName])

func assignAllies(playerTeam : Array[player], enemyTeam : Array[enemy]):
	for member in playerTeam:
		for ally in playerTeam:
			member.allyTeam.append(ally)
	
	for member in enemyTeam:
		for ally in enemyTeam:
			member.allyTeam.append(ally)
