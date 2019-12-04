extends AudioStreamPlayer

# Due to Godot export limitations we have to hard-code this list :/
var music_list = [
	"AiR - Acoustica Mixcraft 7 kg.ogg",
	"AT4RE - Limewire Turbo Accelerator 4.2.7 crk.ogg",
	"CFF - Absolute Uninstaller 2.2 kg.ogg",
	"Enchant - Lucky Luke +2 trn.ogg",
	"ENGiNE - Net Transport 2.42.366 intro.ogg",
	"iOTA - MTop HTML Password Lock 5.0 nfo_2.ogg",
	"JUNLAJUBALAM - JRiver MediaCenter 15.0.xx crk.ogg",
	"JUNLAJUBALAM - Picture to Icon 3.x crk.ogg",
	"kZ - HardCopy Pro 3.3.1 crk.ogg",
	"REVENGE - The Bat! Voyager 3.63.7 crk.ogg",
	"tPORt - AVD Volume Calculator 5.0 crack_0.ogg",
	"tPORt - GIF Movie Gear 4.X.X kg.ogg",
	"Under SEH - AusLogics BoostSpeed 4.1.4.135 crk.ogg",
	"Under SEH - Perfect Uninstaller 6.3.3.9 crk.ogg"
]
var music_index = 0

func _ready():
	randomize()
	music_list.shuffle()

func _process(delta):
	if !playing || Input.is_action_just_pressed("next_music_track"):
		stream = load("res://sounds/music/random/" + music_list[music_index])
		music_index += 1
		if music_index == music_list.size():
			music_index = 0
		play()

# Helper function for updating the above list in the editor
func print_music_list():
	var dir = Directory.new()
	if dir.open("res://sounds/music/random/") == OK:
		dir.list_dir_begin()
		var file = dir.get_next()
		while file != "":
			if !dir.current_is_dir() && file.match("*.ogg"):
				print("\t\"" + file + "\",")
			file = dir.get_next()
