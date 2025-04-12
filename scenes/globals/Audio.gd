extends AudioStreamPlayer2D

enum sfx {
	COLLISION,
	SPLASH,
	MONEY,
	DEATH,
	YAY,
}
var files: Dictionary[sfx, Resource] = {
	sfx.COLLISION: load("res://audio/ship_collision.mp3"),
	sfx.SPLASH: load("res://audio/splash.mp3"),
	sfx.MONEY: load("res://audio/money.mp3"),
	sfx.DEATH: load("res://audio/scream.mp3"),
	sfx.YAY: load("res://audio/yay.mp3"),
}

# credit:
# https://pixabay.com/users/melodyayresgriffiths-27269767/
# Our Life on the Sea - folk pirate sea fiddle adventure soundtrack
func play_menu_music():
	$MusicPlayer.stream = load("res://audio/music_menu.mp3")
	$MusicPlayer.play()

# credit: https://pixabay.com/music/search/sailing/ 
# https://pixabay.com/users/melodyayresgriffiths-27269767/
# Buccaneer -- Swashbuckler Pirate Instrumental High Seas Adventure
func play_level_music():
	$MusicPlayer.stream = load("res://audio/music_level.mp3")
	$MusicPlayer.play()

func play_sfx(sound: sfx):
	$SfxPlayer.stream = files.get(sound)
	$SfxPlayer.play()
	

func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("mute")):
		$MusicPlayer.volume_db = -10 if is_muted() else -80
		$SfxPlayer.volume_db = 0 if is_muted() else -80

func is_muted() -> bool:
	return $MusicPlayer.volume_db == -80
