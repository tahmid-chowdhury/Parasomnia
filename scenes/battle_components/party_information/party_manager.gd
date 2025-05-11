extends Node

var altered_player_index = -1
var party_members = [{
	"name": "Hero",
	"hp": 100,
	"max_hp": 100,
	"mana": 50,
	"strength": 10,
	"defense": 5,
	"speed": 5,
	"level": 1,
	"xp": 0,
	"xp_required": 100,
}]

func _ready():
	randomize()

func level_up_stats(Leveled_Player: String):
	var party_member = find_party_member(Leveled_Player)
	if party_member == -1:
		print("No Party Member Found")
		return -1
		
	while party_members[party_member]["xp"] >= party_members[party_member]["xp_required"]:
			
		var old_xp_required = party_members[party_member]["xp_required"]
		
			
		for stat in party_members[party_member]:
			if stat in ["name", "level", "xp", "xp_required"]:
				continue
			if typeof(party_members[party_member][stat]) == TYPE_INT:
				party_members[party_member][stat] += randi_range(1, 3)
		
		party_members[party_member]["level"] += 1
		party_members[party_member]["xp"] -= old_xp_required
		party_members[party_member]["xp_required"] = int(1.2 * party_members[party_member]["xp_required"])
	return
		
func heal_player(Heal_Player: String, Heal_Amount: int):
	var party_member = find_party_member(Heal_Player)
	if party_member == -1:
		print("No Party Member Found")
		return -1
	party_members[party_member]["hp"] = min(party_members[party_member]["hp"] + Heal_Amount, party_members[party_member]["max_hp"])
	return party_members[party_member]["hp"]
	
	
func damage_player(Damage_Player: String, Damage_Taken: int):
	var party_member = find_party_member(Damage_Player)
	if party_member == -1:
		print("No Party Member Found")
		return -1
	party_members[party_member]["hp"] = max(party_members[party_member]["hp"] - Damage_Taken, 0)
	return party_members[party_member]["hp"]
	
func find_party_member(indicated_party_member: String):
	for party_member in range(party_members.size()):
		if party_members[party_member]["name"] == indicated_party_member:
			altered_player_index = party_member
			return altered_player_index
	return -1
	
func get_random_alive_member() -> int:
	var alive_members = []
	for party_member in range(party_members.size()):
		if party_members[party_member]["hp"] > 0:
			alive_members.append(party_member)
	if alive_members.is_empty():
		return -1
	return alive_members[randi() % alive_members.size()]	
