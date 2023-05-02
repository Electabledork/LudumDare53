extends Node

var colors = [ "#3b1725", "#73172d",
	"#b4202a", "#df3e23", "#fa6a0a", "#f9a31b", "#ffd541",
	"#d6f264", "#59c135", "#14a02e",
	"#1a7a3e", "#24523b", "#143464", "#285cc4",
	"#249fde", "#20d6c7", "#a6fcdb", "#ffffff",
	"#fad6b8", "#f5a097", "#e86a73", "#793a80",
	"#403353", "#71413b",
	"#bb7547", "#4a5462", "#333941", "#422433",
	"#5b3138", "#8e5252", 
	"#588dbe", "#477d85", "#23674e",
	"#328464", "#5daf8d", "#92dcba", "#cdf7e2" ]
	
var resolutions = [
	"1280x800",
	"1280x1024",
	"1360x768",
	"1366x768",
	"1440x900",
	"1600x900",
	"1680x1050",
	"1920x1200",
	"1920x1080",
	"2560x1080",
	"2560x1600",
	"2560x1440",
	"3440x1440",
	"3840x2160",
]

var volume = 0
var mute = false
var resolution = "1152x648"
var borderless = false
var fullscreen = false
var resizable = true

var high_score = 0
var last_score = 0

func _ready():
	load_game()
	set_resolution(resolution)
	set_fullscreen(fullscreen)
	set_borderless(borderless)
	
func set_volume(value):
	volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
	if value <= -1:
		mute = true
	else:
		mute = false
	
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), mute)
		

func set_resolution(res):
	var split = res.split("x")
	var vres = Vector2(int(split[0]), int(split[1]))
	get_window().size = vres

func set_borderless(border):
	if !fullscreen: return
	borderless = border
	get_window().borderless = border
	if border: 
		get_window().mode = Window.MODE_FULLSCREEN
	else:
		get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN

func set_fullscreen(full):
	fullscreen = full
	if full:
		get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN
		get_window().unresizable = true
		resizable = false
		set_resolution(resolution)
		set_borderless(borderless)
	else:
		get_window().mode = Window.MODE_WINDOWED
		get_window().unresizable = false
		resizable = true
	
func set_score(score):
	if score < high_score:
		high_score = score
	
	last_score = score
	
func format_time(time):
	var min = (int)(time)/60
	var sec = floor(time) - (min * 60)
	
	var strmin = "0" + str(min) if min < 10 else str(min)
	var strsec = "0" + str(sec) if sec < 10 else str(sec)

	return str(strmin) + ":" + str(strsec)

func save_game():
	var save_file = FileAccess.open("user://expedited.save", FileAccess.WRITE)
	var save_dict = {
		"volume" : volume,
		"mute" : mute,
		"resolution" : resolution,
		"borderless" : borderless,
		"fullscreen" : fullscreen,
		"resizable" : resizable,
		"high_score": high_score
	}
	var json_string = JSON.stringify(save_dict)
	save_file.store_line(json_string)
	
func load_game():
	if not FileAccess.file_exists("user://expedited.save"):
		save_game()
		return
	
	var save_file = FileAccess.open("user://expedited.save", FileAccess.READ)
	var data = JSON.parse_string(save_file.get_line())
	
	volume = data["volume"]
	mute = data["mute"]
	resolution = data["resolution"]
	borderless = data["borderless"]
	fullscreen = data["fullscreen"]
	resizable = data["resizable"]
	high_score = data["high_score"]
