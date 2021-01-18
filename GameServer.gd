extends Node

var network = NetworkedMultiplayerENet.new()
var port1 = 8080
var port2 = 8788
var M_players = 6
var player_state_collection = {}
var players = 0
func _ready():
	StartServer1()
	
func StartServer1():
	network.create_server(port1, M_players)
	get_tree().network_peer = network
	print("FIRED!!!")
	
	network.connect("peer_connected", self, "_Peer_Connected1")
	network.connect("peer_disconnected", self, "_Peer_Disconnected1")

	
func _Peer_Connected1(player_id):
	print(str(player_id) + " joined")
	rpc_id(0, "SpawnNewPlayer", player_id, Vector2(210,384))
	players += 1
	
func _Peer_Disconnected1(player_id):
	print(str(player_id) + " left")	
	players -= 1
	print("despawning")
		
	player_state_collection.erase(player_id)
	rpc_id(0, "DespawnPlayer", player_id)

remote func DisconnectPlayer():
	

	var player_id = get_tree().get_rpc_sender_id()
	network.disconnect_peer(player_id)
	

remote func SendNumberOfPlayers():
	rpc_id(0, "ReceiveNumberOfPlayers", players)

remote func FetchServerTime(client_time):
	var player_id = get_tree().get_rpc_sender_id()
	rpc_id(player_id, "ReturnServerTime", OS.get_system_time_msecs(), client_time)
	
remote func DetermineLatency(client_time):
	var player_id = get_tree().get_rpc_sender_id()
	rpc_id(player_id, "ReturnLatency", client_time)
	
remote func ReceivePlayerState(player_state):
	
	var player_id = get_tree().get_rpc_sender_id()
	if player_state_collection.has(player_id):
		if player_state_collection[player_id]["T"] < player_state["T"]:
			player_state_collection[player_id] = player_state
	else:
		player_state_collection[player_id]	= player_state
		

		
func SendWorldState(world_state):
	rpc_unreliable_id(0, "ReceiveWorldState", world_state)
	
#remote func SendNPCHit(enemy_id, dmg):
	#get_node("Map").NPCHit(enemy_id, dmg)
	
remote func Attack(position, f_right, can_fire, type, spawn_time):
	var player_id = get_tree().get_rpc_sender_id()
	rpc_id(0, "ReceiveAttack", position, f_right, can_fire, type, spawn_time, player_id)
	
remote func SendMousePosition(target):
	var player_id = get_tree().get_rpc_sender_id()
	rpc_id(0, "ReceiveMousePosition" , target, player_id)
	
remote func SendTeamPick(Pick):
	var player_id = get_tree().get_rpc_sender_id()
	
	rpc_id(0, "ReceiveTeamPick" , Pick, player_id)
remote func SendName(nickname):
	var player_id = get_tree().get_rpc_sender_id()
	rpc_id(0, "ReceiveName" , nickname, player_id)
	
remote func SendPick(Pressed, team):
	var player_id = get_tree().get_rpc_sender_id()
	rpc_id(0, "ReceivePick" , Pressed, team, player_id)
	
remote func SendCharacterPick(pick):
	var player_id = get_tree().get_rpc_sender_id()
	rpc_id(0, "ReceiveCharacterPick" , pick, player_id)
