extends Node2D

# world
@onready var world: World = $World

# player
@onready var player: Player = $Player
@onready var player_hud: PlayerHUD = $PlayerHUD

# coins
@onready var coin_manager: CoinManager = $CoinManager

# enemy
@onready var enemy_manager: EnemyManager = $EnemyManager

func _ready():
	start_game(GameManager.is_new_game, GameManager.saved_game)
	
func start_game(new: bool, saved_data: Dictionary):
	GameManager.reset_player_score()
	if new:
		new_game()
	else:
		load_game(saved_data)


func genarate_save_data() -> Dictionary:
	return {
		"player_score": GameManager.player_score,
		"count_coins": GameManager.count_coins,
		"world": world.genarate_save_data(),
		"player": player.genarate_save_data(),
		"coin_manager": coin_manager.genarate_save_data(),
		"enemy_manager": enemy_manager.genarate_save_data()
	}
	
func new_game() -> void:
	world.setup(true, {})
	player.setup(true, {})
	coin_manager.setup(true, {})
	enemy_manager.setup(true, {})

func load_game(data: Dictionary) -> void:
	GameManager.set_player_score(data["player_score"])
	world.setup(false, data["world"])
	player.setup(false, data["player"])
	coin_manager.setup(false, data["coin_manager"])
	enemy_manager.setup(false, data["enemy_manager"])


func _on_player_hud_game_saved() -> void:
	var data: Dictionary = genarate_save_data()
	Save.save_game(data)
